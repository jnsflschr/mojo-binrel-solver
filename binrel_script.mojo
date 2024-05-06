from utils import Variant


struct Relation(Stringable, Copyable, Movable):
    var val: StaticIntTuple[2]

    fn __init__(inout self, _0: Int, _1: Int):
        self.val = StaticIntTuple(StaticTuple[Int, 2](_0, _1))

    fn __init__(inout self, owned other: Relation):
        self.val = other.val

    fn __init__(inout self, owned other: Tuple[Int, Int]):
        self.val = StaticIntTuple(StaticTuple[Int, 2](other[0], other[1]))

    fn __copyinit__(inout self, existing: Relation) -> None:
        self.val = existing.val

    fn __moveinit__(inout self, owned other: Relation) -> None:
        self.val = other.val

    fn __eq__(self, owned other: Relation) -> Bool:
        return self.__get__(0) == other.__get__(0) and self.__get__(
            1
        ) == other.__get__(2)

    fn __ne__(self, owned other: Relation) -> Bool:
        return not self.__eq__(other)

    fn get(self, index: Int) raises -> Int:
        if index == 0:
            return self.val[0]
        elif index == 1:
            return self.val[1]
        else:
            raise Error("Index out of bounds")

    fn __get__(self, index: Int) -> Int:
        var tup: StaticIntTuple[2] = self.val
        return tup[index]

    fn __bool__(self) -> Relation:
        return self

    fn __str__(self) -> String:
        return "(" + String(self.val[0]) + " , " + String(self.val[1]) + ")"


struct RelationList(Stringable, Copyable):
    var _relations: List[Relation]

    fn __init__(inout self, owned relations: List[Tuple[Int, Int]]):
        self._relations = List[Relation]()
        for relation in relations:
            var r = relation
            self._relations.append(
                Relation(r[].get[0, Int](), r[].get[1, Int]())
            )

    fn __init__(inout self):
        self._relations = List[Relation]()

    fn __copyinit__(inout self, existing: RelationList) -> None:
        self._relations = existing._relations

    fn __moveinit__(inout self, owned other: RelationList) -> None:
        self._relations = other._relations

    fn __get__(inout self) -> List[Relation]:
        return self._relations

    fn __eq__(inout self, owned other: RelationList) -> Bool:
        if self.__len__() != other.__len__():
            return False
        for i in range(self.__len__()):
            if self._relations[i] != other._relations[i]:
                return False
        return True

    fn __len__(self) -> Int:
        return self._relations.__len__()

    fn __contains__(inout self, relation: Relation) -> Bool:
        var found: Bool = False
        for r in self._relations:
            if r[] == relation:
                found = True
                break
        return found

    fn __contains__(inout self, relation: Tuple[Int, Int]) -> Bool:
        var found: Bool = False
        for r in self._relations:
            if r[] == Relation(relation):
                found = True
                break
        return found

    fn __append__(inout self, owned relation: Relation) -> None:
        if relation not in self:
            self._relations.append(relation)

    fn get(inout self) -> List[Relation]:
        return self.__get__()

    fn append(inout self, owned relation: Relation) -> None:
        self.__append__(relation)

    fn append(inout self, owned relation: Tuple[Int, Int]) -> None:
        self.__append__(Relation(relation[0], relation[1]))

    fn extend(inout self, owned relations: RelationList) -> None:
        for relation in relations.get():
            self.__append__(relation[])

    fn __str__(self) -> String:
        var str: String = "{"
        for i in range(self.__len__()):
            str += String(self._relations[i])
            if i < self.__len__() - 1:
                str += ", "
        str += "}"
        return str


# Constants
alias mk_set: List[Int] = List(1, 2, 3, 4)

# Relations
alias r: RelationList = RelationList(List((1, 4), (3, 1), (4, 2), (4, 4)))
alias s: RelationList = RelationList(List((1, 3), (1, 4), (3, 1), (3, 3)))

# Target List
alias target: RelationList = RelationList(List((3, 4)))

alias DEPTH: Int8 = 10


fn compose(r: RelationList, s: RelationList) -> RelationList:
    var c: RelationList = RelationList()
    try:
        for a in r._relations:
            for b in s._relations:
                if a[].get(0) == b[].get(0):
                    c.append((a[].get(0), b[].get(0)))
    except:
        pass
    return c


fn union(r: RelationList, s: RelationList) -> RelationList:
    var c: RelationList = RelationList()
    c.extend(r)
    c.extend(s)
    return c


fn transitive_cl(c: RelationList) -> RelationList:
    var _c: RelationList = c
    var _mk_set: List[Int] = mk_set
    for i in _mk_set:
        for j in _mk_set:
            for k in _mk_set:
                if (i[], j[]) in _c and (j[], k[]) in _c:
                    _c = union(_c, RelationList(List((i[], k[]))))
    return _c


fn transitive_cl(c: RelationList, d: RelationList) -> RelationList:
    return transitive_cl(c)


fn reflexive_cl(c: RelationList) -> RelationList:
    var _c: RelationList = c
    var _mk_set: List[Int] = mk_set
    for i in _mk_set:
        _c = union(_c, RelationList(List((i[], i[]))))
    return _c


fn reflexive_cl(c: RelationList, d: RelationList) -> RelationList:
    return reflexive_cl(c)


fn debug(c: RelationList):
    var sorted_c: RelationList = c
    # print(sorted_c)


def test_functions():
    alias r: RelationList = RelationList(List((1, 4), (3, 1), (4, 2), (4, 4)))
    alias s: RelationList = RelationList(List((1, 3), (1, 4), (3, 1), (3, 3)))

    union_result = union(r, s)
    debug_assert(
        union_result
        == RelationList(List((1, 4), (1, 3), (3, 1), (3, 3), (4, 2), (4, 4))),
        "Union failed",
    )

    compose_result = compose(r, s)
    debug_assert(
        compose_result == RelationList(List((3, 3), (3, 4))), "Compose failed"
    )

    transitive_result = transitive_cl(r)
    debug_assert(
        transitive_result
        == RelationList(
            List((1, 2), (1, 4), (3, 1), (3, 2), (3, 4), (4, 2), (4, 4))
        ),
        "Transitive failed",
    )

    reflexive_result = reflexive_cl(r)
    debug_assert(
        reflexive_result
        == RelationList(
            List((1, 4), (3, 1), (4, 2), (1, 1), (2, 2), (3, 3), (4, 4))
        ),
        "Reflexive failed",
    )

    print("All tests passed")


def apply_operation(
    operation: Variant[
        fn (
            RelationList, RelationList
        ) -> RelationList, fn (RelationList) -> RelationList
    ],
    relation1: RelationList,
    relation2: Variant[NoneType, RelationList] = None,
) -> RelationList:
    if relation2.isa[NoneType]():
        return operation.take[fn (RelationList) -> RelationList]()(relation1)
    else:
        return operation.take[
            fn (RelationList, RelationList) -> RelationList
        ]()(relation1, relation2.take[RelationList]())


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

    fn __contains__(inout self, entry: QueueEntry) -> Bool:
        var found: Bool = False
        for e in self._queue:
            if e[] == entry:
                found = True
                break
        return found

    fn __append__(inout self, owned entry: QueueEntry) -> None:
        if entry not in self:
            self._queue.append(entry)

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

    fn remove(inout self, index: Int) -> None:
        return

    fn pop(inout self, index: Int) -> QueueEntry:
        return self._queue.pop(index)


fn brute_force_relations() -> List[String]:
    var relations: Dict[String, RelationList] = Dict[String, RelationList]()
    relations["r"] = r
    relations["s"] = s

    var operations: Dict[
        String, fn (RelationList, RelationList) -> RelationList
    ] = Dict[String, fn (RelationList, RelationList) -> RelationList]()
    operations["compose"] = compose
    # operations["union"] = union
    operations["transitive_cl"] = transitive_cl
    operations["reflexive_cl"] = reflexive_cl

    var results: List[String] = List[String]()
    var queue = Queue()
    queue.append(QueueEntry(r, 0, "r"))
    queue.append(QueueEntry(s, 0, "s"))
    # Test all combinations of r and s with operations
    while not queue.empty():
        # entry =
        for op in operations.items():
            # Apply operations that require two relations
            if op[].key == "compose" or op[].key == "union":
                for rel1 in relations.items():
                    for rel2 in relations.items():
                        try:
                            var result_relation = op[].value(
                                rel1[].value, rel2[].value
                            )
                            print(result_relation)
                            if result_relation == target:
                                results.append(
                                    "{"
                                    + op[].key
                                    + "}({"
                                    + rel1[].key
                                    + "}, {"
                                    + rel2[].key
                                    + "})"
                                )
                        except Error:
                            continue

            # Apply unary operations (such as transitive and reflexive closures)
            else:
                for rel in relations.items():
                    try:
                        var result_relation = op[].value(
                            rel[].value, rel[].value
                        )
                        print(result_relation)
                        if result_relation == target:
                            results.append(
                                "{" + op[].key + "}({" + rel[].key + "})"
                            )
                    except Error:
                        continue

    return results


fn main() -> None:
    try:
        test_functions()
    except:
        pass

    var results: List[String] = List[String]()
    try:
        results = brute_force_relations()
    except:
        pass
    # Test all combinations of r and s with operations

    # Display all results that match the target
    for result in results:
        print("Matching relation found with: {result}")
