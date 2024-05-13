from collections.set import Set
from algorithm.sort import sort

struct Relation(Stringable, Copyable, Movable, KeyElement):
    var val: StaticIntTuple[2]

    fn __init__(inout self, _0: Int, _1: Int):
        self.val = StaticIntTuple(StaticTuple[Int, 2](_0, _1))

    fn __init__(inout self, other: Relation):
        self.val = StaticIntTuple(other.val.data)
    
    fn __init__(inout self):
        self.val = StaticIntTuple(StaticTuple[Int, 2]())

    fn __init__(inout self, other: Tuple[Int, Int]):
        self.val = StaticIntTuple(StaticTuple[Int, 2](other[0], other[1]))

    fn __copyinit__(inout self, existing: Relation) -> None:
        # self.val = existing.val
        var tup = StaticTuple[Int, 2](existing.val.data[0], existing.val.data[1])
        self.val = StaticIntTuple(tup)

    fn __moveinit__(inout self, owned other: Relation) -> None:
        self.val = other.val

    fn __eq__(self, other: Relation) -> Bool:
        return self.__get__(0) == other.__get__(0) and self.__get__(
            1
        ) == other.__get__(1)

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
    
    @staticmethod
    fn cmp(a: Relation, b: Relation) capturing -> Bool:
        return a.val[0] < b.val[0] or (a.val[0] == b.val[0] and a.val[1] < b.val[1])


struct RelationList(Stringable, Copyable, KeyElement):
    var _relations: Set[Relation]

    fn __init__(inout self, list: List[Tuple[Int, Int]]):
        self._relations = Set[Relation]()
        var rel_list: List[Relation] = List[Relation]()
        for r in list:
            var relation = Relation(r[].get[0, Int](), r[].get[1, Int]())
            rel_list.append(relation)
        self._relations = Set[Relation](rel_list)

    fn __init__(inout self):
        self._relations = Set[Relation]()
    
    fn to_list(self) -> List[Relation]:
        var list: List[Relation] = List[Relation]()
        for relation in self._relations:
            list.append(relation[])
        return list
    
    @staticmethod
    fn to_list(list: List[Tuple[Int, Int]]) -> List[Relation]:
        var rel_list: List[Relation] = List[Relation]()
        for entry in list:
            rel_list.append((entry[].get[0, Int](), entry[].get[1, Int]()))
        return rel_list

    fn __copyinit__(inout self, existing: RelationList) -> None:
        self._relations = Set[Relation]()
        for relation in existing._relations:
            var rel = Relation(relation[])
            self._relations.add(rel)

    fn __moveinit__(inout self, owned other: RelationList) -> None:
        self._relations = Set[Relation]()
        for relation in other._relations:
            self._relations.add(relation[])

    fn __get__(self) -> Dict[Relation, NoneType]:
        var copy = Set[Relation]()
        for relation in self._relations:
            copy.add(relation[])
        return copy._data
    
    fn __getitem__(self, index: Int) raises -> Relation:
        var i: Int = 0
        for relation in self._relations:
            if i == index:
                return relation[]
            i += 1
        raise Error("Index out of bounds")

    fn __eq__(self, other: RelationList) -> Bool:
        return self._relations == other._relations
    
    fn __ne__(self, other: RelationList) -> Bool:
        return not self.__eq__(other)

    fn __len__(self) -> Int:
        return self._relations.__len__()

    fn __contains__(self, relation: Relation) -> Bool:
        var found: Bool = False
        for r in self._relations:
            if r[] == relation:
                found = True
                break
        return found

    fn __contains__(self, relation: Tuple[Int, Int]) -> Bool:
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
        self._relations.update(relations._relations)
        # self.update(relations)
        return
    
    fn update (inout self, relations: RelationList) -> None:
        var list = relations.to_list()
        var rel_set: Set[Relation] = Set[Relation](list)
        for relation in relations._relations:
            rel_set.add(relation[])
        
        for relation in rel_set:
            self._relations.add(relation[])
        # self._relations
    
    fn extend(inout self, relations: List[Tuple[Int, Int]]) -> None:
        var rel_list: List[Relation] = RelationList.to_list(relations)
        self._relations = self._relations.union(Set[Relation](rel_list))

    fn __str__(self) -> String:
        var list: List[Relation] = self.to_list()
        return RelationList.to_string(list)

    fn to_string(self) -> String:
        return self.__str__()
    
    @staticmethod
    fn to_string(list: List[Relation]) -> String:
        var list_cp: List[Relation] = list
        sort[Relation, Relation.cmp](list_cp)
        var str: String = "{"
        for i in range(len(list_cp)):
            str += String(list_cp[i])
            if i < len(list_cp) - 1:
                str += ", "
        str += "}"
        return str
    
    @staticmethod
    fn to_string(list: List[Tuple[Int, Int]]) -> String:
        return RelationList.to_string(RelationList.to_list(list))
    
    fn __hash__(self) -> Int:
        # var hash: Int = 0
        # for relation in self._relations:
        #     hash += relation[].__hash__()
        # return hash
        return hash[Set[Relation]](self._relations)
    
    fn empty(self) -> Bool:
        return self._relations.__len__() == 0

fn test() raises -> None:
    var r1: RelationList = RelationList(List[Tuple[Int, Int]]((1,2), (2,3), (3,4)))
    var r2: RelationList = RelationList(List[Tuple[Int, Int]]((5,2), (2,3), (3,4)))
    var r3: RelationList = RelationList(List[Tuple[Int, Int]]((6,2), (2,3), (3,4)))

    print(r1)
    print(r2)
    print(r3)

    var r1_init_Tuple = RelationList(List[Tuple[Int, Int]]((1,2), (2,3), (3,4)))
    var r1_init_Empty = RelationList()
    r1_init_Empty.extend(List[Tuple[Int, Int]]((1,2), (2,3), (3,4)))
    if r1 != r1_init_Tuple or r1 != r1_init_Empty:
        raise Error("Init not working")

    if len(r1) != 3:
        raise Error("Length not working")
    
    if (1,2) not in r1 or (3, 3) in r1:
        raise Error("Contains not working")
    
    if String(r1) != "{(1 , 2), (2 , 3), (3 , 4)}":
        raise Error("to_string not working")
    
    if r1[0] != Relation(1,2) or r1[1] != Relation(2,3) or r1[2] != Relation(3,4):
        raise Error("getitem not working")

    r1.append((1,3))
    var r1_after_append = RelationList(List[Tuple[Int, Int]]((1,2), (2,3), (3,4), (1,3)))
    if r1 != r1_after_append:
        raise Error("Append not working")

    r1.extend(r2)
    var r1_after_extend = RelationList(List[Tuple[Int, Int]]((1,2), (2,3), (3,4), (1,3), (5,2)))
    if r1 != r1_after_extend:
        raise Error("Extend not working")
    
    if r1 != r1 or r1 == r2 or r1 == r3:
        raise Error("Equality not working")
    
    if r1.__hash__() == r2.__hash__() or r1.__hash__() == r3.__hash__():
        raise Error("Hash not working")
    
    print("relations: all tests passed")


fn main() -> None:
    try:
        test()
    except e:
        print(e)
        pass
    finally:
        print("Done")