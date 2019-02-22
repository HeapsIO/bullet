# Bullet

[Bullet Physics](https://github.com/bulletphysics) wrapper for Heaps

Supports both HashLink and JS output thanks to [WebIDL](https://github.com/ncannasse/webidl)

## Compilation

Download the Bullet sources and put them in hashlink/src/bullet directory.
Then run `make gen_hl`
Then open an compile `bullet.sln`

Requires having hashlink one level upper than bullet directory, such as:

```
/hashlink
/libs
   /bullet
```

