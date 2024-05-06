from relation import RelationList, Relation

struct QueueEntry:
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

    fn __eq__(self, owned other: QueueEntry) -> Bool:
        return other.relation == self.relation

    fn __ne__(self, owned other: QueueEntry) -> Bool:
        return not self.__eq__(other)

    fn __str__(self) -> String:
        return (
            "Relation: "
            + String(self.relation)
            + ", Depth: "
            + String(self.depth)
        )


struct Queue:
    var _queue: List[QueueEntry]

    fn __init__(inout self):
        self._queue = List[QueueEntry]()

    fn __init__(inout self, owned other: Queue):
        self._queue = other._queue

    fn __copyinit__(inout self, existing: Queue) -> None:
        self._queue = existing._queue

    fn __moveinit__(inout self, owned other: Queue) -> None:
        self._queue = other._queue

    fn __len__(self) -> Int:
        return self._queue.__len__()

    fn __contains__(inout self, r: RelationList) -> Bool:
        var found: Bool = False
        for e in self._queue:
            if e[].relation == r:
                found = True
                break
        return found

    fn find(inout self, entry: QueueEntry) -> Int:
        var index: Int = -1
        for i in range(self.__len__()):
            if self._queue[i].relation == entry.relation:
                index = i
                break
        return index

    fn __append__(inout self, owned entry: QueueEntry) -> None:
        if entry.relation not in self:
            self._queue.append(entry)
        else:
            var existing_index: Int = self.find(entry)
            if self._queue[existing_index].depth > entry.depth:
                self._queue[existing_index] = entry

    fn append(inout self, owned entry: QueueEntry) -> None:
        self.__append__(entry)

    fn get(inout self) -> List[QueueEntry]:
        return self._queue

    fn __str__(self) -> String:
        var str: String = "{"
        for i in range(self.__len__()):
            str += String(self._queue[i].relation)
            if i < self.__len__() - 1:
                str += ", "
        str += "}"
        return str

    fn empty(self) -> Bool:
        return self.__len__() == 0

    fn pop(inout self, index: Int) -> QueueEntry:
        return self._queue.pop(index)
