package bach.impl

import bach.spi.AppendableStore
import com.google.gson.Gson
import java.io.FileWriter
import scala.reflect.ClassTag

case class FileStore[A: ClassTag](path: String) extends AppendableStore[A] {

  private val gson = new Gson

  override def iterator: Iterator[A] = {
    import scala.sys.process._
    val iter = Seq("tail", "-f", path).lazyLines.map(deserialize).iterator

    /**
      * The infinite iterator's hasNext must always be true, since we use akka stream in
      * listen() function. In code akka.stream.stage.GraphStageLogic.pushPull, it will
      * still check hasNext() after next() is called. hasNext() should never block after
      * next() is consumed.
      */
    Iterator.continually { iter.next }
  }

  override def append(data: A): Unit = {
    val fw = new FileWriter(path, true)
    try {
      fw.write(serialize(data))
      fw.write(System.lineSeparator)
      fw.flush()
    } finally fw.close()
  }

  private def deserialize(raw: String): A = gson.fromJson(raw, implicitly[ClassTag[A]].runtimeClass)

  private def serialize(data: A): String = gson.toJson(data)
}
