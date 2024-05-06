from utils import Variant
from relation import RelationList, Relation
from operations import compose, union, transitive_cl, reflexive_cl, apply_operation
from queue import Queue, QueueEntry

# Relations
alias r: RelationList = RelationList(List((1, 4), (3, 1), (4, 2), (4, 4)))
alias s: RelationList = RelationList(List((1, 3), (1, 4), (3, 1), (3, 3)))

# Target List
alias target: RelationList = RelationList(List((3, 4)))

alias DEPTH: Int8 = 20
alias DEBUG: Bool = True

fn debug(relation: RelationList) -> None:
    if DEBUG:
        print(relation)
    return

fn debug(msg: String, relation: RelationList) -> None:
    if DEBUG:
        print(msg + " " + relation)
    return


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
        for entry1 in queue.items():
            var rel1 = entry1[].relation
            var rel1_path = entry1[].path
            var rel1_depth = entry1[].depth
            for op in operations.items():
                debug(op[].key, entry1[].relation)
                # Apply operations that require two relations
                if op[].key == "compose" or op[].key == "union":
                    for entry2 in queue.items():
                        var rel2 = entry2[].relation
                        var rel2_path = entry2[].path
                        var rel2_depth = entry2[].depth

                        try:
                            var result_relation = op[].value(
                                rel1, rel2
                            )
                            debug(result_relation)
                            if result_relation == target:
                                results.append(
                                    ""
                                    + op[].key
                                    + "("
                                    + rel1_path
                                    + ", "
                                    + rel2_path
                                    + ")"
                                )
                            else:
                                queue.append(
                                    QueueEntry(result_relation, rel1_depth + rel2_depth + 1, op[].key + "(" + rel1_depth + ", " + rel2_path + ")")
                                )
                        except Error:
                            continue
                # Apply unary operations (such as transitive and reflexive closures)
                else:
                    try:
                        var result_relation = apply_operation(op[].value, rel1, rel1)
                        debug(result_relation)
                        if result_relation == target:
                            results.append(
                                "" + op[].key + "(" + rel1_path + ")"
                            )
                        else:
                            queue.append(
                                QueueEntry(result_relation, rel1_depth + 1, op[].key + "(" + rel1_path + ")")
                            )
                    except Error:
                        continue
                # try:
                #     if entry1[].relation != target:
                #         queue.remove(entry1[])
                # except:
                #     pass
    return results


fn main() -> None:
    var results: List[String] = List[String]()
    results = brute_force_relations()

    # Test all combinations of r and s with operations

    # Display all results that match the target
    for result in results:
        print("Matching relation found with: {result}")
