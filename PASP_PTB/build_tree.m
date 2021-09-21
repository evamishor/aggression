function [tree_elem] =  build_tree(t, idx, L)
tree_elem.left_idx = t(idx, 1);
tree_elem.right_idx = t(idx, 2);
tree_elem.distance = t(idx, 3);
if tree_elem.left_idx > L
    tree_elem.left = build_tree(t, tree_elem.left_idx - L, L);
else
    tree_elem.left = tree_elem.left_idx;
end
if tree_elem.right_idx > L
    tree_elem.right = build_tree(t, tree_elem.right_idx - L, L);
else
    tree_elem.right = tree_elem.right_idx;
end
end