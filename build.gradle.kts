import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar
import org.gradle.api.tasks.testing.logging.TestExceptionFormat
import org.gradle.api.tasks.testing.logging.TestLogEvent
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

val databaseUrl: String by project
val databaseUsername: String by project
val databasePassword: String by project

repositories {
    mavenCentral()

    maven {
        url = uri("https://maven.pkg.jetbrains.space/public/p/kotlinx-html/maven")
    }
}

configurations {
    compileClasspath {
        resolutionStrategy.activateDependencyLocking()
    }
}

dependencyLocking {
    lockAllConfigurations()
}

buildscript {
    repositories {
        maven {
            url = uri("https://plugins.gradle.org/m2/")
        }
    }
}

plugins {
    application
    kotlin("jvm") version "2.1.10"
}

application {
    mainClass.set("au.edu.aaf.verifid.MainKt")
}

tasks.withType<ShadowJar> {
    archiveFileName.set("verifid.jar")
    manifest {
        attributes(
            "Bundle-Version" to "0.0.0",
            "Main-Class" to "au.edu.aaf.verifid.MainKt",
        )
    }
}

kotlin {
    jvmToolchain {
        (this as JavaToolchainSpec).languageVersion.set(JavaLanguageVersion.of(11))
    }
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "11"
}

tasks.withType<Test> {
    useJUnitPlatform()
}

dependencies {
    implementation("ch.qos.logback:logback-classic:1.5.16")
}

tasks.withType<ShadowJar> {
    archiveFileName.set("verifid.jar")
    manifest {
        attributes(
            "Bundle-Version" to "0.0.0",
            "Main-Class" to "au.edu.aaf.verifid.MainKt",
        )
    }
}

tasks.test {
    useJUnitPlatform()
    maxParallelForks = 2
    failFast = true
    minHeapSize = "64m"
    maxHeapSize = "512m"
    jvmArgs = listOf("-Xmx2048m", "-Dio.ktor.development=false")

    if (project.properties["ci"] == "true") {
        testLogging {
            events = setOf(TestLogEvent.FAILED, TestLogEvent.PASSED, TestLogEvent.SKIPPED)
            exceptionFormat = TestExceptionFormat.FULL

            showExceptions = true
            showCauses = true
            showStackTraces = true
        }
    }
}

tasks.register<Copy>("copyRuntimeDependencies") {
    from(configurations.runtimeClasspath)
    into("build/dependency")
}

tasks["build"].dependsOn("copyRuntimeDependencies")
