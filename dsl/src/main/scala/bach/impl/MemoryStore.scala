package bach.impl

import bach.spi.AppendableStore
import scala.collection.mutable.ListBuffer

case class MemoryStore[A]() extends AppendableStore[A] {

  val list = ListBuffer[A]()

  override def iterator: Iterator[A] = {
    import util.control.Breaks._
    var pos = 0
    Iterator.continually {
      breakable {
        while (true) {
          if (pos == list.size) {
            Thread.sleep(1000)
          } else {
            break
          }
        }
      }
      pos = pos + 1
      list(pos - 1)
    }
  }

  override def append(data: A): Unit = {
    list += data
    ()
  }
}
