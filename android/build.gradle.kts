allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// Some plugins (e.g. image_cropper) still compile against android-33, which
// their androidx dependencies reject (they require 34+). Force every Android
// module to the app's compileSdk. Registered in its own block BEFORE the
// evaluationDependsOn block below, so the afterEvaluate hook is added while the
// project is still un-evaluated (avoiding "already evaluated" errors), and it
// runs after each plugin's own android{} block so it wins over their 33.
subprojects {
    afterEvaluate {
        extensions.findByName("android")?.let { ext ->
            if (ext is com.android.build.gradle.BaseExtension) {
                ext.compileSdkVersion(37)
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
