package bach.spi

trait AppendableStore[A] {

  def iterator: Iterator[A]

  def append(data: A)

  def tail
}
