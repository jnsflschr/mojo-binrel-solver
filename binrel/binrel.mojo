from utils import Variant
from binrel.relation import RelationList, Relation
from binrel.operations import Operation
from binrel.queue import Queue, QueueEntry
from collections import Set

# Relations
var r: RelationList = RelationList(List((1, 4), (3, 1), (4, 2), (4, 4)))
var s: RelationList = RelationList(List((1, 3), (1, 4), (3, 1), (3, 3)))

# Target List
var target: RelationList = RelationList(List((3, 4)))

alias DEPTH: Int8 = 30
alias DEBUG: Bool = False


fn debug(message: String) -> None:
    @parameter
    if DEBUG:
        print(message)
    return


fn debug(relation: RelationList) -> None:
    @parameter
    if DEBUG:
        print(relation)
    return


fn debug(operation: String, relation: RelationList) -> None:
    @parameter
    if DEBUG:
        print(operation + "(" + relation + ")")
    return


fn debug(
    operation: String, relation1: RelationList, relation2: RelationList
) -> None:
    @parameter
    if DEBUG:
        print(operation + "(" + relation1 + ", " + relation2 + ")")
    return


fn brute_force_relations() -> List[QueueEntry]:
    var relations: Dict[String, RelationList] = Dict[String, RelationList]()
    relations["R"] = r
    relations["S"] = s

    var operations: Dict[
        String, fn (RelationList, RelationList) -> RelationList
    ] = Dict[String, fn (RelationList, RelationList) -> RelationList]()

    operations["+"] = Operation.union
    operations["."] = Operation.compose
    operations["transitive_cl"] = Operation.transitive_cl
    operations["reflexive_cl"] = Operation.reflexive_cl

    var results: Set[QueueEntry] = List[QueueEntry]()
    var queue: Queue = Queue()
    queue.append(QueueEntry(r, 1, "R"))
    queue.append(QueueEntry(s, 1, "S"))

    # Test all combinations of r and s with operations
    var check_queue: Queue = Queue()
    var check_count: Int8 = 0
    while not queue.empty():
        check_queue = queue
        # print(String(queue) + "\n")
        for entry1 in queue.items():
            print(String(entry1[]))
            var rel1 = entry1[].relation
            var rel1_path = entry1[].path
            var rel1_depth = entry1[].depth
            for op in operations.items():
                # Apply operations that require two relations
                if op[].key == "." or op[].key == "+":
                    for entry2 in queue.items():
                        var rel2_depth = entry2[].depth
                        if not (rel1_depth + rel2_depth + 1) > DEPTH:
                            var rel2 = entry2[].relation
                            var rel2_path = entry2[].path
                            try:
                                debug(op[].key, rel1, rel2)
                                var result_relation = op[].value(rel1, rel2)
                                debug(result_relation)
                                var entry = QueueEntry(
                                    result_relation,
                                    rel1_depth + rel2_depth + 1,
                                    "("
                                    + rel1_path
                                    + " "
                                    + op[].key
                                    + " "
                                    + rel2_path
                                    + ")",
                                )
                                if result_relation == target:
                                    results.add(entry)
                                else:
                                    queue.append(entry)
                            except Error:
                                continue
                # Apply unary operations (such as transitive and reflexive closures)
                elif op[].key == "transitive_cl" or op[].key == "reflexive_cl":
                    try:
                        debug(op[].key, rel1)
                        var result_relation = Operation.apply_operation(
                            op[].value, rel1, rel1
                        )
                        debug(result_relation)
                        var entry = QueueEntry(
                            result_relation,
                            rel1_depth + 1,
                            op[].key + "(" + rel1_path + ")",
                        )
                        if result_relation == target:
                            results.add(entry)
                        else:
                            queue.append(entry)
                    except Error:
                        continue
                # try:
                #     if entry1[].relation != target:
                #         queue.remove(entry1[])
                # except:
                #     pass
        if check_queue == queue:
            # break
            if check_count > 1:
                print("No new relations found.")
                break
            check_count += 1
        else:
            check_count = 0
        check_queue.clear()

    var res_list: List[QueueEntry] = List[QueueEntry]()
    for res in results:
        res_list.append(res[])
    return res_list


fn filter_results(results: List[QueueEntry]) -> List[QueueEntry]:
    var filtered_results: List[QueueEntry] = List[QueueEntry]()
    for result in results:
        if result[].relation == target:
            if len(filtered_results) == 0:
                filtered_results.append(result[])
            elif result[].depth < filtered_results[0].depth:
                filtered_results.clear()
                filtered_results.append(result[])
    return filtered_results
