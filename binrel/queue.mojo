from binrel.relation import RelationList, Relation
from collections import InlinedFixedVector as Vector
from algorithm.sort import sort


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
        var depth = String(self.depth)
        if self.depth < 10:
            depth = " " + depth
        return (
            "Depth: "
            + depth
            + ", Relation: "
            + String(self.relation)
            + ", Path: "
            + self.path
        )

    fn to_string(self) -> String:
        return self.__str__()

    @staticmethod
    fn to_string(relation: RelationList, depth: Int8, path: String) -> String:
        return (
            "Relation: "
            + String(relation)
            + ", Depth: "
            + String(depth)
            + ", Path: "
            + path
        )

    fn __hash__(self) -> Int:
        var rel_hash: Int = hash[RelationList](self.relation)
        var depth_hash: Int = int[Int8](self.depth)
        return rel_hash + depth_hash

    @staticmethod
    fn cmp(a: QueueEntry, b: QueueEntry) capturing -> Bool:
        if a.depth < b.depth:
            return True
        # elif a.depth > b.depth:
        #     return False
        else:
            return False


struct Queue:
    var _queue: List[QueueEntry]

    fn __init__(inout self):
        self._queue = List[QueueEntry]()

    fn __init__(inout self, owned other: Queue):
        self = other

    fn __copyinit__(inout self, existing: Queue) -> None:
        self._queue = List[QueueEntry](existing._queue)

    fn __moveinit__(inout self, owned existing: Queue) -> None:
        self._queue = List[QueueEntry](existing._queue)

    fn __len__(self) -> Int:
        return len(self._queue)

    fn __contains__(self, r: RelationList) -> Bool:
        var found: Bool = False
        for e in self._queue:
            if e[].relation == r:
                found = True
                break
        return found

    fn findIndex(self, relation: RelationList) -> Int:
        for i in range(len(self._queue)):
            if self._queue[i].relation == relation:
                return i
        return -1

    fn find(self, relation: RelationList) -> QueueEntry:
        var index: Int = self.findIndex(relation)
        if index == -1:
            return QueueEntry(RelationList(), -1, "")
        return self._queue[index]

    fn __eq__(self, other: Queue) -> Bool:
        if len(self) != len(other):
            return False
        var list_self = self._queue
        var list_other = other._queue
        sort[QueueEntry, QueueEntry.cmp](list_self)
        sort[QueueEntry, QueueEntry.cmp](list_other)
        for i in range(len(list_self)):
            if list_self[i] != list_other[i]:
                return False
        return True

    fn clear(inout self) -> None:
        self._queue = List[QueueEntry]()

    fn __append__(inout self, owned entry: QueueEntry) -> None:
        if entry.relation not in self:
            # print("Adding to queue: ", entry.relation, " with depth: ", entry.depth)
            self._queue.append(entry)
        else:
            var existing_index: Int = self.findIndex(entry.relation)
            if entry.depth < self._queue[existing_index].depth:
                self._queue[existing_index].depth = entry.depth
                self._queue[existing_index].path = entry.path

    fn append(inout self, owned entry: QueueEntry) -> None:
        if entry.relation.empty():
            return
        self.__append__(entry)

    fn __str__(self) -> String:
        var list: List[QueueEntry] = List[QueueEntry]()
        for e in self._queue:
            list.append(e[])

        var str: String = "{\n"
        for i in range(self.__len__()):
            str += "\t"
            str += String(list[i])
            if i < self.__len__() - 1:
                str += ", \n"
        str += "\n}"
        return str

    fn empty(self) -> Bool:
        return self.__len__() == 0

    fn pop(inout self) raises -> QueueEntry:
        return self._queue.pop()

    fn items(self) -> List[QueueEntry]:
        var list = self._queue
        sort[QueueEntry, QueueEntry.cmp](list)
        return list

    # fn remove(inout self, entry: QueueEntry) raises -> None:
    #     self._queue.remove(entry)

    fn max_depth(self) -> Int8:
        var max_depth: Int8 = -1
        for e in self._queue:
            if e[].depth > max_depth:
                max_depth = e[].depth
        return max_depth


fn test_queue() raises -> None:
    var q: Queue = Queue()
    var r1: RelationList = RelationList(
        List[Tuple[Int, Int]]((1, 2), (2, 3), (3, 4))
    )
    var r2: RelationList = RelationList(
        List[Tuple[Int, Int]]((2, 2), (2, 3), (3, 4))
    )
    var r1_entry = QueueEntry(r1, 1, "1->2->3->4")
    var r1_entry_copy = QueueEntry(r1, 3, "1->2->2->4")
    q.append(r1_entry)
    var r2_entry = QueueEntry(r2, 2, "2->2->3->4")
    q.append(r2_entry)

    if q.empty():
        raise "queue: empty() failed"

    if q.max_depth() != 2:
        raise "queue: max_depth() failed"

    if len(q) != 2:
        raise "queue: len() failed"

    var str_should_be: String = String(
        "Relation: " + String(r1) + ", Depth: 1, Path: 1->2->3->4"
    )
    if (
        r1_entry.to_string() == ""
        or r1_entry.to_string() != str_should_be
        or r1_entry.to_string() != QueueEntry.to_string(r1, 1, "1->2->3->4")
    ):
        print("should be", str_should_be)
        print("object method", r1_entry.to_string())
        print("static method", QueueEntry.to_string(r1, 1, "1->2->3->4"))
        raise "queue: to_string() failed"

    if q.find(r1) != QueueEntry(r1, 1, "1->2->3->4"):
        raise "queue: find() failed"

    q.append(r1_entry_copy)
    if len(q) != 2 or q.max_depth() != 2:
        raise "queue: append() failed"

    # try:
    #     q.remove(r1_entry_copy)
    #     raise "queue: remove() failed - should not throw exception"
    # except:
    #     pass
    # if len(q) != 2:
    #     raise "queue: remove() failed - should not remove entry with other depth"

    # q.remove(r1_entry)
    # if len(q) != 1:
    #     raise "queue: remove() failed"

    q.append(r1_entry)
    var count: Int = 0
    for e in q.items():
        count += 1
        if (e[].relation == r1 and e[].depth == 1) or (
            e[].relation == r2 and e[].depth == 2
        ):
            continue
        else:
            raise "queue: items() failed - wrong items in queue"
    if count != 2:
        raise "queue: items() failed - wrong number of items in queue"

    var res = q.find(r1)
    if res.relation != r1 or res.depth != 1:
        raise "queue: find() failed - wrong entry found"
    # q.remove(r1_entry)
    # res = q.find(r1)
    # if res.relation == r1 or res.depth != -1:
    #     raise "queue: find() failed - entry should not be found"

    print("queue: all tests passed")


# fn main():
#     try:
#         test()
#     except e:
#         print(e)
#         pass
#     finally:
#         print("Done")
