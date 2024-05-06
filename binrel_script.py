mk_set: set[int] = {1, 2, 3, 4}

# Relations
r = {(1, 4), (3, 1), (4, 2), (4, 4)}
s = {(1, 3), (1, 4), (3, 1), (3, 3)}

# Target set
target = {(3, 4)}

DEPTH = 10


def compose(r: set[tuple[int, int]], s: set[tuple[int, int]]):
    return {(x, z) for x, _ in r for __, z in s if _ == __}

def union(r: set[tuple[int, int]], s: set[tuple[int, int]]):
    _r = r.copy()
    _s = s.copy()
    return _r.union(_s)

def transitive_cl(c: set[tuple[int, int]]):
    _c = c.copy()
    for i in mk_set:
        for j in mk_set:
            for k in mk_set:
                if (i, j) in _c and (j, k) in _c:
                    _c = _c.union({(i, k)})
    return _c

def reflexive_cl(c: set[tuple[int, int]]):
    _c = c.copy()
    for i in mk_set:
        _c = _c.union({(i, i)})
    return _c

def debug(c: set[tuple[int, int]]):
    sorted_c = sorted(c)
    print(sorted_c)
    
def test_functions():
    r = {(1, 4), (3, 1), (4, 2), (4, 4)}
    s = {(1, 3), (1, 4), (3, 1), (3, 3)}
    
    union_result = union(r, s)
    assert union_result == {(1, 4), (1, 3), (3, 1), (3, 3), (4, 2), (4, 4)}
    
    compose_result = compose(r, s)
    assert compose_result == {(3 , 3) , (3 , 4)}
    
    transitive_result = transitive_cl(r)
    assert transitive_result == {(1 , 2) , (1 , 4) , (3 , 1) , (3 , 2) , (3 , 4) , (4 , 2) , (4 , 4)}
    
    reflexive_result = reflexive_cl(r)
    assert reflexive_result == {(1 , 4) , (3 , 1) , (4 , 2) , (1 , 1) , (2 , 2) , (3 , 3) , (4 , 4)}
    

def brute_force_relations():
    relations = {'r': r, 's': s}
    operations = {
        'union': union,
        'compose': compose,
        'transitive_cl': transitive_cl,
        'reflexive_cl': reflexive_cl
    }
    
    results = []
    queue = [(key, relations[key]) for key in relations]
    
    # Evaluate up to depth 3
    for _ in range(DEPTH):
        new_queue = []
        for op_key in operations:
            for name1, rel1 in queue:
                if op_key in ['transitive_cl', 'reflexive_cl']:
                    result = operations[op_key](rel1)
                    new_name = f"{op_key}({name1})"
                    new_queue.append((new_name, result))
                    if result == target:
                        results.append(new_name)
                        break
                else:
                    for name2, rel2 in queue:
                        result = operations[op_key](rel1.copy(), rel2)
                        new_name = f"{op_key}({name1}, {name2})"
                        new_queue.append((new_name, result))
                        if result == target:
                            results.append(new_name)
                            break
                        
        queue.extend(new_queue)
    
    return results



if __name__ == "__main__":
    test_functions()
    
    results = brute_force_relations()
    # Test all combinations of r and s with operations
    

    # Display all results that match the target
    for result in results:
        print(f"Matching relation found with: {result}")
