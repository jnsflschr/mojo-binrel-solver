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