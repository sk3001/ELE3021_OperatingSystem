First Milestone
===============

## Design
There are 13 data address blocks, 12 are direct blocks and one is single indirect block. To support at least 64MB, triple indirect block is needed. To do this, 2 of the direct block should be changed to double and triple address block.



## Definitions
#### fs.h
```c++
#define NDIRECT 10
#define NINDIRECT (BSIZE / sizeof(uint))
#define NDINDIRECT (NINDIRECT * NINDIRECT)
#define NTINDIRECT (NINDIRECT * NDINDIRECT)
#define MAXFILE (NDIRECT + NINDIRECT + NDINDIRECT + NTINDIRECT)
```
* Reduce `NDIRECT` by 2 because of double and triple address blocks.
* `NDINDIRECT` is double indirect block
* `NTINDIRECT` is triple indirect block

#### file.h
```c
struct inode {
  (...)
  uint addrs[NDIRECT+3];
};

```
Changed the length of `addrs` for double and triple indirect blocks.

#### param.h


#### bmap
`bmap` is modified to support double and triple indirect blocks. They are implemented similar to indirect block. Single indirect blocks use addrs[NDIRECT], double indirect block uses addr[NDIRECT+1], and triple indirect block uses addr[NDIRECT+2], address is assigned in the corresponding index in each mode.

In the case of double indirection, to divide the address into two parts, the first part of address as the first block and the second part as the second block, handled it with the share(/) and rest(%) operations. In case of triple, used 3 indexes, bn / NDINDIRECT, (bn % NDINDIRECT) / NINDIRECT, bn % NINDIRECT to separate address.

#### itrunc
On indirect blocks, it was necessary to get along the block and remove all the blocks inside it. truncate blocks by interation on single indirect is possible. But in double or triple, used double and triple for loop to reach to the deepest data block.

