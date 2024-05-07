from utils import Variant
from relation import RelationList, Relation

alias mk_set: List[Int] = List(1, 2, 3, 4)

struct Operation:
    @staticmethod
    fn compose(r: RelationList, s: RelationList) -> RelationList:
        var c: RelationList = RelationList()
        try:
            for a in r._relations:
                for b in s._relations:
                    if a[].get(1) == b[].get(0):
                        c.append((a[].get(0), b[].get(1)))
        except e:
            print(e)
            pass
        return c

    @staticmethod
    fn union_rel(r: RelationList, s: RelationList) -> RelationList:
        var c: RelationList = RelationList()
        c.extend(r)
        c.extend(s)
        return c

    @staticmethod
    fn union(r: RelationList, s: RelationList) -> RelationList:
        var c: RelationList = RelationList()
        c.extend(r)
        c.extend(s)
        return c

    @staticmethod
    fn transitive_cl(c: RelationList) -> RelationList:
        var _c: RelationList = c
        var _mk_set: List[Int] = mk_set
        for i in _mk_set:
            for j in _mk_set:
                for k in _mk_set:
                    if (i[], j[]) in _c and (j[], k[]) in _c:
                        _c = Operation.union_rel(_c, RelationList(List((i[], k[]))))
        return _c

    @staticmethod
    fn transitive_cl(c: RelationList, d: RelationList) -> RelationList:
        return Operation.transitive_cl(c)

    @staticmethod
    fn reflexive_cl(c: RelationList) -> RelationList:
        var _c: RelationList = c
        var _mk_set: List[Int] = mk_set
        for i in _mk_set:
            _c = Operation.union_rel(_c, RelationList(List((i[], i[]))))
        return _c

    @staticmethod
    fn reflexive_cl(c: RelationList, d: RelationList) -> RelationList:
        return Operation.reflexive_cl(c)


    @staticmethod
    fn apply_operation(
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

fn debug(c: RelationList):
    var sorted_c: RelationList = c
    # print(sorted_c)

fn test() raises -> None:
    var r: RelationList = RelationList(List((1, 4), (3, 1), (4, 2), (4, 4)))
    var s: RelationList = RelationList(List((1, 3), (1, 4), (3, 1), (3, 3)))

    var union_result = Operation.union(r, s)
    var union_should_be = RelationList(List((1, 4), (1, 3), (3, 1), (3, 3), (4, 2), (4, 4)))
    # print(union_result)
    if union_result != union_should_be:
        print(union_result)
        print(union_should_be)
        raise "Union failed"

    var compose_result = Operation.compose(r, s)
    var compose_should_be = RelationList(List((3, 3), (3, 4)))
    if compose_result != RelationList(List((3, 3), (3, 4))):
        print(compose_result)
        print(compose_should_be)
        raise "Compose failed"

    var transitive_result = Operation.transitive_cl(r)
    var transitive_should_be = RelationList(List((1 , 2) , (1 , 4) , (3 , 1) , (3 , 2) , (3 , 4) , (4 , 2) , (4 , 4)))
    if transitive_result != transitive_should_be:
        print(transitive_result)
        print(transitive_should_be)
        raise "Transitive failed"

    var reflexive_result = Operation.reflexive_cl(r)
    var reflexive_should_be = RelationList(List((1, 4), (3, 1), (4, 2), (4, 4), (1, 1), (2, 2), (3, 3)))
    if reflexive_result != reflexive_should_be:
        print(reflexive_result)
        print(reflexive_should_be)
        raise "Reflexive failed"

    print("operations: all tests passed")

fn main():
    try:
        test()
    except e:
        print(e)
        pass
    finally:
        print("Done")