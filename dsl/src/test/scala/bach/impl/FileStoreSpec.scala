package bach.impl

import org.scalatest._
import bach.util._

class FileStoreSpec extends FlatSpec with Matchers {
  "FileStore append data" should "be iteratable" in {
    val f = FileStore[Int](FileUtil.getTempFile)
    f.append(1)
    f.iterator.next should be(1)
  }

  "FileStore" should "handle newline correctly even though newline is used as separator" in {
    val f = FileStore[String](FileUtil.getTempFile)
    f.append("hi\nworld")
    f.iterator.next should be("hi\nworld")
  }

  "FileStores" should "be composable by listen()" in {
    val f1 = FileStore[Int](FileUtil.getTempFile)
    val f2 = FileStore[Int](FileUtil.getTempFile)
    f1.listen(f2)
    f2.append(1)
    f1.iterator.next should be(1)
  }
}
