from utils import Variant
from relation import RelationList, Relation

alias mk_set: List[Int] = List(1, 2, 3, 4)

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

def main():
    test_functions()