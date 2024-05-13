
from testing import assert_true, assert_false, assert_raises
from .. import Operation, RelationList

def test_operations():
    var r: RelationList = RelationList(List((1, 4), (3, 1), (4, 2), (4, 4)))
    var s: RelationList = RelationList(List((1, 3), (1, 4), (3, 1), (3, 3)))

    var union_result = Operation.union(r, s)
    var union_should_be = RelationList(List((1, 4), (1, 3), (3, 1), (3, 3), (4, 2), (4, 4)))
    # print(union_result)
    assert_true(union_result == union_should_be)
    if union_result != union_should_be:
        print(union_result)
        print(union_should_be)
        raise "Union failed"

    var compose_result = Operation.compose(r, s)
    var compose_should_be = RelationList(List((3, 3), (3, 4)))
    assert_true(compose_result == compose_should_be)
    if compose_result != RelationList(List((3, 3), (3, 4))):
        print(compose_result)
        print(compose_should_be)
        raise "Compose failed"

    var transitive_result = Operation.transitive_cl(r)
    var transitive_should_be = RelationList(List((1 , 2) , (1 , 4) , (3 , 1) , (3 , 2) , (3 , 4) , (4 , 2) , (4 , 4)))
    assert_true(transitive_result == transitive_should_be)
    if transitive_result != transitive_should_be:
        print(transitive_result)
        print(transitive_should_be)
        raise "Transitive failed"

    var reflexive_result = Operation.reflexive_cl(r)
    var reflexive_should_be = RelationList(List((1, 4), (3, 1), (4, 2), (4, 4), (1, 1), (2, 2), (3, 3)))
    assert_true(reflexive_result == reflexive_should_be)
    if reflexive_result != reflexive_should_be:
        print(reflexive_result)
        print(reflexive_should_be)
        raise "Reflexive failed"

    print("operations: all tests passed")

fn main():
    try:
        with assert_raises():
            test_operations()
    except e:
        print(e)
        pass
    finally:
        print("Done")