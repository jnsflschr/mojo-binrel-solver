from utils import Variant
from relation import RelationList, Relation
from operations import compose, union, transitive_cl, reflexive_cl, apply_operation
from queue import Queue, QueueEntry

# Relations
alias r: RelationList = RelationList(List((1, 4), (3, 1), (4, 2), (4, 4)))
alias s: RelationList = RelationList(List((1, 3), (1, 4), (3, 1), (3, 3)))

# Target List
alias target: RelationList = RelationList(List((3, 4)))

alias DEPTH: Int8 = 10




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
    var queue: Queue = Queue()
    queue.append(QueueEntry(r, 0, "r"))
    queue.append(QueueEntry(s, 0, "s"))

    # Test all combinations of r and s with operations
    while not queue.empty():
        var entry1: QueueEntry = queue.pop(0)
        if entry1.depth == DEPTH:
            continue
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
                            elif result_relation not in queue:
                                queue.append(
                                    QueueEntry(result_relation, entry.depth + 1, op[].key + "(" + rel1[].key + ", " + rel2[].key + ")")
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
    var results: List[String] = List[String]()
    results = brute_force_relations()

    # Test all combinations of r and s with operations

    # Display all results that match the target
    for result in results:
        print("Matching relation found with: {result}")
