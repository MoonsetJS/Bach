package bach.impl

import org.scalatest._
import bach.util._

class AppendableStoreSpec extends FlatSpec with Matchers {
  "MemoryStore and FileStore" should "be composable by listen()" in {
    val f = FileStore[Int](FileUtil.getTempFile)
    val m = MemoryStore[Int]()
    m.listen(f)
    f.append(1)
    m.iterator.next should be(1)
  }
}
