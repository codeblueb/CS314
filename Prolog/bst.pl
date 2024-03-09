%%%% binary search trees in prolog.  

insert(Item,null, bstree(Item,null,null)).

insert(ToInsert,bstree(OldData,LT,RT),bstree(OldData, NewLeft, RT)) :- 
    ToInsert< OldData,
    insert(ToInsert,LT,NewLeft).

insert(ToInsert,bstree(OldData,LT,RT),bstree(OldData, LT, NewRight)) :- 
    ToInsert >= OldData,
    insert(ToInsert,RT, NewRight).

inorder(null,[ ]).
inorder(bstree(Item,LT,RT),Inorder) :- 
          inorder(LT,Left),
          inorder(RT,Right),
          append(Left,[Item|Right],Inorder).

insert_all([ ], Tree, Tree).
insert_all([H | T], Tree, ResTree):- insert(H, Tree, Tree1), insert_all(T, Tree1, ResTree).

treeSort(L, LS):- insert_all(L, null, Tree), inorder(Tree, LS).
