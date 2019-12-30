package bach.impl

import bach.spi.AppendableStore
import scala.collection.mutable.ListBuffer

case class MemoryStore[A]() extends AppendableStore[A] {

  val list = ListBuffer[A]()

  override def iterator = list.iterator

  override def append(data: A) = {
    list += data
    ()
  }

  override def tail = {
    var pos = 0
    while(true) {
      if(pos == list.size) {
        Thread.sleep(1000)
      } else {
        println(list(pos))
        pos = pos + 1
      }
    }
  }
}
