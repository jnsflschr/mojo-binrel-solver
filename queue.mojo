from relation import RelationList, Relation
from collections import Set

struct QueueEntry(KeyElement):
    var relation: RelationList
    var path: String
    var depth: Int8

    fn __init__(
        inout self, owned relation: RelationList, depth: Int8, path: String
    ):
        self.relation = relation
        self.depth = depth
        self.path = path

    fn __init__(inout self, owned other: QueueEntry):
        self.relation = other.relation
        self.depth = other.depth
        self.path = other.path

    fn __copyinit__(inout self, existing: QueueEntry) -> None:
        self.relation = existing.relation
        self.depth = existing.depth
        self.path = existing.path

    fn __moveinit__(inout self, owned other: QueueEntry) -> None:
        self.relation = other.relation
        self.depth = other.depth
        self.path = other.path

    fn __eq__(self, other: QueueEntry) -> Bool:
        return other.relation == self.relation

    fn __ne__(self, other: QueueEntry) -> Bool:
        return not self.__eq__(other)

    fn __str__(self) -> String:
        return (
            "Relation: "
            + String(self.relation)
            + ", Depth: "
            + String(self.depth)
        )
    
    fn __hash__(self) -> Int:
        return hash(self.relation)


struct Queue:
    var _queue: Set[QueueEntry]

    fn __init__(inout self):
        self._queue = Set[QueueEntry]()

    fn __init__(inout self, owned other: Queue):
        self = other

    fn __copyinit__(inout self, existing: Queue) -> None:
        self._queue = Set[QueueEntry]()
        for e in existing._queue:
            self._queue.add(e[])

    fn __moveinit__(inout self, owned existing: Queue) -> None:
        self._queue = Set[QueueEntry]()
        for e in existing._queue:
            self._queue.add(e[])

    fn __len__(self) -> Int:
        return self._queue.__len__()

    fn __contains__(inout self, r: RelationList) -> Bool:
        var found: Bool = False
        for e in self._queue:
            if e[].relation == r:
                found = True
                break
        return found

    fn find(inout self, relation: RelationList) -> QueueEntry:
        for qe in self._queue:
            if qe[].relation == relation:
                return qe[]
        return QueueEntry(RelationList(), -1, "")

    fn __append__(inout self, owned entry: QueueEntry) -> None:
        if entry.relation not in self:
            print("Adding to queue: ", entry.relation, " with depth: ", entry.depth)
            self._queue.add(entry)
        else:
            var existing_entry: QueueEntry = self.find(entry.relation)
            if existing_entry.depth == -1:
                return
            if existing_entry.depth > entry.depth:
                try:
                    self._queue.remove(existing_entry)
                except:
                    pass
                self._queue.add(entry)

    fn append(inout self, owned entry: QueueEntry) -> None:
        self.__append__(entry)

    fn __str__(self) -> String:
        var list: List[QueueEntry] = List[QueueEntry]()
        for e in self._queue:
            list.append(e[])
        
        var str: String = "{"
        for i in range(self.__len__()):
            str += String(list[i].relation)
            if i < self.__len__() - 1:
                str += ", "
        str += "}"
        return str

    fn empty(self) -> Bool:
        return self.__len__() == 0

    fn pop(inout self) raises -> QueueEntry:
        return self._queue.pop()

    fn items(inout self) -> List[QueueEntry]:
        var list: List[QueueEntry] = List[QueueEntry]()
        for e in self._queue:
            list.append(e[])
        return list

    fn remove(inout self, entry: QueueEntry) raises -> None:
        self._queue.remove(entry)