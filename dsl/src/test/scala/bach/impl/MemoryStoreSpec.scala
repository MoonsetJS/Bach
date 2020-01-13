package bach.impl

import org.scalatest._

class MemoryStoreSpec extends FlatSpec with Matchers {
  "MemoryStore append data" should "be iteratable" in {
    val m = MemoryStore[Int]()
    m.append(1)
    m.iterator.next should be(1)
  }

  "MemoryStores" should "be composable by listen()" in {
    val m1 = MemoryStore[Int]()
    val m2 = MemoryStore[Int]()
    m1.listen(m2)
    m2.append(1)
    m1.iterator.next should be(1)
  }
}
