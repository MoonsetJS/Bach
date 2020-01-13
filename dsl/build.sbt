scalaVersion := "2.13.1"

name := "Bach"
organization := "Bach"
version := "1.0"

libraryDependencies += "com.google.code.gson" % "gson" % "2.8.6"
libraryDependencies += "com.typesafe.akka" %% "akka-stream" % "2.6.1"
libraryDependencies += "org.scalatest" %% "scalatest" % "3.1.0" % "test"

// To let compile task depend on scalafmtAll task and scalastyle. The order matters, we want
// to execute scalafmtAll first and then scalastyle..
// The toTask() trick is from this post: https://github.com/scalastyle/scalastyle-sbt-plugin/issues/11
(Compile / compile) := ((Compile / compile) dependsOn (Compile / scalastyle).toTask("")).value
(Compile / compile) := ((Compile / compile) dependsOn scalafmtAll).value
