from collections import Set

struct Relation(Stringable, Copyable, Movable, KeyElement):
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

    fn __eq__(self, other: Relation) -> Bool:
        return self.__get__(0) == other.__get__(0) and self.__get__(
            1
        ) == other.__get__(2)

    fn __ne__(self, other: Relation) -> Bool:
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
    
    fn __hash__(self) -> Int:
        return (self.val[0]*10) + self.val[1]


struct RelationList(Stringable, Copyable, KeyElement):
    var _relations: Set[Relation]

    fn __init__(inout self, owned relations: List[Tuple[Int, Int]]):
        self._relations = Set[Relation]()
        for relation in relations:
            var r = relation
            self._relations.add(
                Relation(r[].get[0, Int](), r[].get[1, Int]())
            )

    fn __init__(inout self):
        self._relations = Set[Relation]()

    fn __copyinit__(inout self, existing: RelationList) -> None:
        self._relations = Set[Relation]()
        for relation in existing._relations:
            self._relations.add(relation[])

    fn __moveinit__(inout self, owned other: RelationList) -> None:
        self._relations = Set[Relation]()
        for relation in other._relations:
            self._relations.add(relation[])

    # fn __get__(inout self) -> Set[Relation]:
    #     var copy = Set[Relation]()
    #     for relation in self._relations:
    #         copy.add(relation[])
    #     return copy.

    fn __eq__(self, other: RelationList) -> Bool:
        return self._relations == other._relations
    
    fn __ne__(self, other: RelationList) -> Bool:
        return not self.__eq__(other)

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
            self._relations.add(relation)

    # fn get(inout self) -> Set[Relation]:
    #     return self.__get__()

    fn append(inout self, owned relation: Relation) -> None:
        self.__append__(relation)

    fn append(inout self, owned relation: Tuple[Int, Int]) -> None:
        self.__append__(Relation(relation[0], relation[1]))

    fn extend(inout self, relations: RelationList) -> None:
        self._relations = self._relations.union(relations._relations)

    fn __str__(self) -> String:
        var list: List[Relation] = List[Relation]()
        for relation in self._relations:
            list.append(relation[])
        var str: String = "{"
        for i in range(self.__len__()):
            str += String(list[i])
            if i < self.__len__() - 1:
                str += ", "
        str += "}"
        return str
    
    fn __hash__(self) -> Int:
        var hash: Int = 0
        for relation in self._relations:
            hash += relation[].__hash__()
        return hash
