package bach.util

import java.io.File

object FileUtil {

  def getTempFile = {
    val file = File.createTempFile("foo", ".tmp")
    file.deleteOnExit
    file.getAbsolutePath
  }
}
