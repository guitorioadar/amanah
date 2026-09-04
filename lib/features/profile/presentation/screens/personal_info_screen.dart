import 'package:amanah/core/media/media_prep.dart';
import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_avatar.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/core/widgets/app_text_field.dart';
import 'package:amanah/core/widgets/media_viewer.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:amanah/features/profile/data/profile_repository.dart';
import 'package:amanah/features/profile/presentation/providers/profile_providers.dart';
import 'package:amanah/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

/// Fixed dial code — Canada per design (the flag/code are not user-editable).
const _kDialCode = '+1';

/// Personal information: fixed header, scrollable form (avatar + Name / Email
/// (locked) / Role (locked) / Phone / Address), and a pinned "Save changes"
/// bar. Saves through [ProfileRepository]; mocks succeed until the API ships.
class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() =>
      _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  bool _saving = false;
  bool _uploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _name = TextEditingController(text: user?.name ?? '');
    // User.mobileNumber stores digits only (dial code kept separately until
    // the API defines its phone shape).
    final raw = user?.mobileNumber ?? '';
    _phone = TextEditingController(
      text: raw.startsWith('+') ? raw.substring(1) : raw,
    );
    _address = TextEditingController(text: user?.address?.addressLine ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final user = ref.read(currentUserProvider);
    try {
      // The repository returns the post-save user (as the real API will);
      // cache THAT instead of hand-merging fields client-side.
      final updated = await ref.read(profileRepositoryProvider).updateProfile(
            ProfileUpdate(
              name: _name.text.trim(),
              mobileNumber: _phone.text.trim(),
              mobileCountryCode: _kDialCode,
              address: _address.text.trim(),
              profilePictureUrl: user?.profilePictureUrl,
            ),
          );
      if (!mounted) return;
      await ref.read(currentUserProvider.notifier).setUser(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Changes saved')),
        );
      Navigator.of(context).pop();
    } on Object catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text("Couldn't save changes. Try again.")),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Pick → free-form crop (square or rectangle) → multipart upload.
  Future<void> _changePhoto() async {
    final picked = await FilePicker.pickFiles(type: FileType.image);
    final path = picked.isEmpty ? null : picked.first.path;
    if (path == null) return;

    // Convert heic (and enforce 100 MB) before cropping — the cropper and the
    // backend both want jpg/png.
    if (!mounted) return;
    final prepared = await prepareMedia(
      context,
      path: path,
      kind: MediaPrepKind.image,
    );
    if (prepared == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: prepared,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop photo',
          toolbarColor: AppColors.bgSolid,
          toolbarWidgetColor: AppColors.textInverse,
          activeControlsWidgetColor: AppColors.brand,
          // Free-form: any aspect (square or rectangle), user can lock presets.
          lockAspectRatio: false,
          hideBottomControls: false,
        ),
        IOSUiSettings(title: 'Crop photo'),
      ],
    );
    if (cropped == null) return;

    setState(() => _uploadingPhoto = true);
    try {
      final url = await ref
          .read(profileRepositoryProvider)
          .updateProfilePicture(cropped.path);
      if (!mounted) return;
      final current = ref.read(currentUserProvider);
      if (current != null) {
        await ref
            .read(currentUserProvider.notifier)
            .setUser(current.copyWith(profilePictureUrl: url));
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Photo updated')));
    } on Object catch (e) {
      if (!mounted) return;
      final msg = e is ApiException
          ? e.message
          : "Couldn't update photo. Try again.";
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final topInset = MediaQuery.of(context).viewPadding.top;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark,
      child: Scaffold(
        backgroundColor: AppColors.bgDefault,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.s2),
            ProfileTopBar(title: 'Personal information', topInset: topInset),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.s6),
                      _AvatarSection(
                        avatarUrl: user?.profilePictureUrl,
                        loading: _uploadingPhoto,
                        onChangePhoto: _uploadingPhoto ? null : _changePhoto,
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              label: 'Name',
                              labelStyle: AppText.bodySRegular,
                              controller: _name,
                              textInputAction: TextInputAction.next,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Enter your name'
                                  : null,
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            AppTextField(
                              label: 'Email address',
                              labelStyle: AppText.bodySRegular,
                              controller:
                                  TextEditingController(text: user?.email ?? ''),
                              enabled: false,
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            _LockedDropdown(
                              label: 'Role',
                              value: user?.roleLabel ?? 'Auditor',
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            _PhoneField(controller: _phone),
                            const SizedBox(height: AppSpacing.s4),
                            AppTextField(
                              label: 'Address',
                              labelStyle: AppText.bodySRegular,
                              controller: _address,
                              hint: 'Enter address',
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: AppSpacing.s6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Pinned action bar.
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.s4,
                AppSpacing.s3,
                AppSpacing.s4,
                AppSpacing.s3 + bottomInset,
              ),
              child: AppButton(
                label: 'Save changes',
                onPressed: _saving ? null : _save,
                loading: _saving,
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Avatar + "Change photo" button. Tapping picks an image, lets the user crop
/// it, then uploads it; a spinner overlays the avatar while uploading.
class _AvatarSection extends StatelessWidget {
  const _AvatarSection({
    required this.avatarUrl,
    required this.loading,
    required this.onChangePhoto,
  });

  final String? avatarUrl;
  final bool loading;
  final VoidCallback? onChangePhoto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: (avatarUrl == null || avatarUrl!.isEmpty || loading)
                  ? null
                  : () => showMediaViewer(
                        context,
                        items: [MediaItem.networkImage(avatarUrl!)],
                      ),
              child: AppAvatar(
                url: avatarUrl,
                size: 80,
                borderColor: AppColors.borderDefault,
                borderWidth: 1,
              ),
            ),
            if (loading)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.scrim,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.brandOnPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s3),
        OutlinedButton(
          onPressed: onChangePhoto,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textDefault,
            side: BorderSide(color: AppColors.borderDefault),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s5,
              vertical: AppSpacing.s2,
            ),
          ),
          child: Text(
            'Change photo',
            style: AppText.bodyMMedium.copyWith(color: AppColors.textDefault),
          ),
        ),
      ],
    );
  }
}

/// Field label matching the design (Body/S/Regular above the input).
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s2),
      child: Text(
        text,
        style: AppText.bodySRegular.copyWith(color: AppColors.textDefault),
      ),
    );
  }
}

/// Read-only dropdown look (Role is assigned by the org, not editable).
class _LockedDropdown extends StatelessWidget {
  const _LockedDropdown({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(label),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
          decoration: BoxDecoration(
            color: AppColors.bgInput,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppText.bodyLRegular
                      .copyWith(color: AppColors.textSubtlest),
                ),
              ),
              const Icon(
                Icons.expand_more,
                size: 20,
                color: AppColors.iconSubtle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Phone row: fixed Canada flag + dial code, then the editable number.
class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _FieldLabel('Phone number'),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.bgDefault,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.s3),
              const Text('🇨🇦', style: TextStyle(fontSize: 18)),
              const SizedBox(width: AppSpacing.s2),
              Text(
                _kDialCode,
                style:
                    AppText.bodyLRegular.copyWith(color: AppColors.textDefault),
              ),
              Container(
                width: 1,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
                color: AppColors.borderDefault,
              ),
              Expanded(
                // Raw field (isDense + zero padding) so it fits the fixed 48pt
                // row; a full AppTextField sizes taller and overflows by 2px.
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style:
                      AppText.bodyLRegular.copyWith(color: AppColors.textDefault),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Add phone number',
                    hintStyle: AppText.bodyLRegular
                        .copyWith(color: AppColors.textSubtlest),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
            ],
          ),
        ),
      ],
    );
  }
}
