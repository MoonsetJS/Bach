package bach.spi

import akka.actor.ActorSystem
import akka.stream.scaladsl.Source

trait AppendableStore[A] {

  private implicit val system = ActorSystem("ApppendableStore")

  def iterator: Iterator[A]

  def append(data: A): Unit

  def tail: Unit = {
    iterator.foreach(println)
    ()
  }

  def listen(store: AppendableStore[A]): Unit = {
    Source.fromIterator[A](() => store.iterator).runForeach(append)
    ()
  }
}
