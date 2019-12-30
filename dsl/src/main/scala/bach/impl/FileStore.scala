package bach.impl

import bach.spi.AppendableStore
import com.google.gson.Gson
import java.io.FileWriter
import scala.io.Source
import scala.reflect.ClassTag
import scala.sys.process._


case class FileStore[A: ClassTag](path: String) extends AppendableStore[A] {

  private val gson = new Gson

  override def iterator = Source.fromFile(path).getLines.map(deserialize)

  override def append(data: A) = {
    val fw = new FileWriter(path, true)
    try {
      fw.write(serialize(data))
      fw.write(System.lineSeparator)
    }
    finally fw.close() 
  }

  override def tail = Seq("tail", "-f", path).lazyLines.foreach(l => println(deserialize(l)))

  private def deserialize(raw: String): A = gson.fromJson(raw, implicitly[ClassTag[A]].runtimeClass)

  private def serialize(data: A): String = gson.toJson(data)
}
