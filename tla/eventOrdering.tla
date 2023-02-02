--------------------------- MODULE eventOrdering ---------------------------

EXTENDS Sequences, Integers, TLC, FiniteSets
CONSTANTS Writer, Readers, Data, NULL, MaxQueue

ASSUME Writer \notin Readers
ASSUME NULL \notin Data

SeqOf(set, n) == UNION {[1..m -> set] : m \in 0..n}
seq (+) elem == Append(seq, elem)

(*--algorithm polling
variables 
  queue = <<>>; \* Ordered messages

define
  TypeInvariant ==
    queue \in SeqOf(Data, MaxQueue)
end define;

process writer = Writer
variable d \in Data
begin
  Write:
    while TRUE do
      queue := queue (+) d;
    end while;
end process;

process reader \in Readers
variables local = NULL;
begin
  Read:
    while TRUE do
      await queue /= <<>>;
      local := Head(queue);
      queue := Tail(queue);
    end while;
end process;

end algorithm; *)
====

Data <- [model value] {d1, d2}
MaxQueue <- 3
NULL <- [model value]
Readers <- [model value] {r1, r2}
Writer <- [model value]


INVARIANT TypeInvariant
CONSTRAINT Len(queue) < MaxQueue

====
