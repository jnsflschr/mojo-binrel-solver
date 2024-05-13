from binrel import brute_force_relations, filter_results


fn main() -> None:
    var results = brute_force_relations()
    var filtered = filter_results(results)

    # Test all combinations of r and s with operations

    # Display all results that match the target
    if len(results) == 0:
        print("No matching relations found.")
    else:
        for result in results:
            print("Relation found with: " + String(result[]))
        for result in filtered:
            print("Best relation found with: " + String(result[]))
