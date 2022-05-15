
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 7e 10 80       	push   $0x80107ec0
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 b5 4f 00 00       	call   80105010 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 7e 10 80       	push   $0x80107ec7
80100097:	50                   	push   %eax
80100098:	e8 43 4e 00 00       	call   80104ee0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 67 50 00 00       	call   80105150 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 a9 50 00 00       	call   80105210 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 4d 00 00       	call   80104f20 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 7e 10 80       	push   $0x80107ece
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 0d 4e 00 00       	call   80104fc0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 7e 10 80       	push   $0x80107edf
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 cc 4d 00 00       	call   80104fc0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 4d 00 00       	call   80104f80 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 40 4f 00 00       	call   80105150 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 af 4f 00 00       	jmp    80105210 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 7e 10 80       	push   $0x80107ee6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 bf 4e 00 00       	call   80105150 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 b6 44 00 00       	call   80104780 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 90 3a 00 00       	call   80103d70 <myproc>
801002e0:	8b 40 28             	mov    0x28(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 1c 4f 00 00       	call   80105210 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 be 4e 00 00       	call   80105210 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 7e 10 80       	push   $0x80107eed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 2f 89 10 80 	movl   $0x8010892f,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 53 4c 00 00       	call   80105030 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 7f 10 80       	push   $0x80107f01
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 91 66 00 00       	call   80106ad0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 df 65 00 00       	call   80106ad0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 65 00 00       	call   80106ad0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 65 00 00       	call   80106ad0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 e7 4d 00 00       	call   80105310 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 1a 4d 00 00       	call   80105260 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 7f 10 80       	push   $0x80107f05
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 7f 10 80 	movzbl -0x7fef80d0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 30 4b 00 00       	call   80105150 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 c4 4b 00 00       	call   80105210 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 ec 4a 00 00       	call   80105210 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 7f 10 80       	mov    $0x80107f18,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 5b 49 00 00       	call   80105150 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 7f 10 80       	push   $0x80107f1f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 28 49 00 00       	call   80105150 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100856:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 83 49 00 00       	call   80105210 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100911:	68 c0 0f 11 80       	push   $0x80110fc0
80100916:	e8 65 40 00 00       	call   80104980 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010093d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100964:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 f4 40 00 00       	jmp    80104a90 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 7f 10 80       	push   $0x80107f28
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 3b 46 00 00       	call   80105010 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 1a 11 80 00 	movl   $0x80100600,0x80111a8c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 1a 11 80 70 	movl   $0x80100270,0x80111a88
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 4f 33 00 00       	call   80103d70 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 87 71 00 00       	call   80107c20 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 45 6f 00 00       	call   80107a40 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 53 6e 00 00       	call   80107980 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 29 70 00 00       	call   80107ba0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 91 6e 00 00       	call   80107a40 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 da 6f 00 00       	call   80107ba0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 7f 10 80       	push   $0x80107f41
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 b5 70 00 00       	call   80107cc0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 42 48 00 00       	call   80105480 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 2f 48 00 00       	call   80105480 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 be 71 00 00       	call   80107e20 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 54 71 00 00       	call   80107e20 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 70             	add    $0x70,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 31 47 00 00       	call   80105440 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 08             	mov    0x8(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 1c             	mov    0x1c(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 08             	mov    %edx,0x8(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 b7 6a 00 00       	call   801077f0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 5f 6e 00 00       	call   80107ba0 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 4d 7f 10 80       	push   $0x80107f4d
80100d6b:	68 e0 10 11 80       	push   $0x801110e0
80100d70:	e8 9b 42 00 00       	call   80105010 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 11 11 80       	mov    $0x80111114,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 10 11 80       	push   $0x801110e0
80100d91:	e8 ba 43 00 00       	call   80105150 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 1a 11 80    	cmp    $0x80111a74,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 10 11 80       	push   $0x801110e0
80100dc1:	e8 4a 44 00 00       	call   80105210 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 e0 10 11 80       	push   $0x801110e0
80100dda:	e8 31 44 00 00       	call   80105210 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 10 11 80       	push   $0x801110e0
80100dff:	e8 4c 43 00 00       	call   80105150 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 10 11 80       	push   $0x801110e0
80100e1c:	e8 ef 43 00 00       	call   80105210 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 7f 10 80       	push   $0x80107f54
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 10 11 80       	push   $0x801110e0
80100e51:	e8 fa 42 00 00       	call   80105150 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 10 11 80 	movl   $0x801110e0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 8f 43 00 00       	jmp    80105210 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 e0 10 11 80       	push   $0x801110e0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 63 43 00 00       	call   80105210 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 7f 10 80       	push   $0x80107f5c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 7f 10 80       	push   $0x80107f66
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 6f 7f 10 80       	push   $0x80107f6f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 7f 10 80       	push   $0x80107f75
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 f8 1a 11 80    	add    0x80111af8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 7f 7f 10 80       	push   $0x80107f7f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d e0 1a 11 80    	mov    0x80111ae0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 f8 1a 11 80    	add    0x80111af8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 e0 1a 11 80       	mov    0x80111ae0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 e0 1a 11 80    	cmp    %eax,0x80111ae0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 92 7f 10 80       	push   $0x80107f92
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 f6 3f 00 00       	call   80105260 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 34 1b 11 80       	mov    $0x80111b34,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 00 1b 11 80       	push   $0x80111b00
801012aa:	e8 a1 3e 00 00       	call   80105150 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 54 37 11 80    	cmp    $0x80113754,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 54 37 11 80    	cmp    $0x80113754,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 00 1b 11 80       	push   $0x80111b00
8010130f:	e8 fc 3e 00 00       	call   80105210 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 00 1b 11 80       	push   $0x80111b00
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 ce 3e 00 00       	call   80105210 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 a8 7f 10 80       	push   $0x80107fa8
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 b8 7f 10 80       	push   $0x80107fb8
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 aa 3e 00 00       	call   80105310 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 40 1b 11 80       	mov    $0x80111b40,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 cb 7f 10 80       	push   $0x80107fcb
80101491:	68 00 1b 11 80       	push   $0x80111b00
80101496:	e8 75 3b 00 00       	call   80105010 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 d2 7f 10 80       	push   $0x80107fd2
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 2c 3a 00 00       	call   80104ee0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 60 37 11 80    	cmp    $0x80113760,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 e0 1a 11 80       	push   $0x80111ae0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 f8 1a 11 80    	pushl  0x80111af8
801014d5:	ff 35 f4 1a 11 80    	pushl  0x80111af4
801014db:	ff 35 f0 1a 11 80    	pushl  0x80111af0
801014e1:	ff 35 ec 1a 11 80    	pushl  0x80111aec
801014e7:	ff 35 e8 1a 11 80    	pushl  0x80111ae8
801014ed:	ff 35 e4 1a 11 80    	pushl  0x80111ae4
801014f3:	ff 35 e0 1a 11 80    	pushl  0x80111ae0
801014f9:	68 38 80 10 80       	push   $0x80108038
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d e8 1a 11 80 01 	cmpl   $0x1,0x80111ae8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d e8 1a 11 80    	cmp    %ebx,0x80111ae8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 f4 1a 11 80    	add    0x80111af4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 cd 3c 00 00       	call   80105260 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 d8 7f 10 80       	push   $0x80107fd8
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 f4 1a 11 80    	add    0x80111af4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 da 3c 00 00       	call   80105310 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 00 1b 11 80       	push   $0x80111b00
8010165f:	e8 ec 3a 00 00       	call   80105150 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
8010166f:	e8 9c 3b 00 00       	call   80105210 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 79 38 00 00       	call   80104f20 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 f4 1a 11 80    	add    0x80111af4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 f3 3b 00 00       	call   80105310 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 f0 7f 10 80       	push   $0x80107ff0
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 ea 7f 10 80       	push   $0x80107fea
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 48 38 00 00       	call   80104fc0 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 ec 37 00 00       	jmp    80104f80 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 ff 7f 10 80       	push   $0x80107fff
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 5b 37 00 00       	call   80104f20 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 a1 37 00 00       	call   80104f80 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
801017e6:	e8 65 39 00 00       	call   80105150 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 00 1b 11 80 	movl   $0x80111b00,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 0b 3a 00 00       	jmp    80105210 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 00 1b 11 80       	push   $0x80111b00
80101810:	e8 3b 39 00 00       	call   80105150 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
8010181f:	e8 ec 39 00 00       	call   80105210 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 04 39 00 00       	call   80105310 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 80 1a 11 80 	mov    -0x7feee580(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 08 38 00 00       	call   80105310 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 84 1a 11 80 	mov    -0x7feee57c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 dd 37 00 00       	call   80105380 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 7e 37 00 00       	call   80105380 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 19 80 10 80       	push   $0x80108019
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 07 80 10 80       	push   $0x80108007
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 f2 20 00 00       	call   80103d70 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 00 1b 11 80       	push   $0x80111b00
80101c89:	e8 c2 34 00 00       	call   80105150 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80101c99:	e8 72 35 00 00       	call   80105210 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 16 36 00 00       	call   80105310 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 83 35 00 00       	call   80105310 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 5e 35 00 00       	call   801053e0 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 28 80 10 80       	push   $0x80108028
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 16 87 10 80       	push   $0x80108716
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 94 80 10 80       	push   $0x80108094
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 8b 80 10 80       	push   $0x8010808b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 a6 80 10 80       	push   $0x801080a6
8010200b:	68 80 b5 10 80       	push   $0x8010b580
80102010:	e8 fb 2f 00 00       	call   80105010 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 20 3e 11 80       	mov    0x80113e20,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 80 b5 10 80       	push   $0x8010b580
8010208e:	e8 bd 30 00 00       	call   80105150 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 8a 28 00 00       	call   80104980 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 b5 10 80       	push   $0x8010b580
8010210f:	e8 fc 30 00 00       	call   80105210 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 8d 2e 00 00       	call   80104fc0 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 b5 10 80       	push   $0x8010b580
80102168:	e8 e3 2f 00 00       	call   80105150 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 b5 10 80       	push   $0x8010b580
801021b8:	53                   	push   %ebx
801021b9:	e8 c2 25 00 00       	call   80104780 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 35 30 00 00       	jmp    80105210 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 c0 80 10 80       	push   $0x801080c0
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 aa 80 10 80       	push   $0x801080aa
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 d5 80 10 80       	push   $0x801080d5
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 54 37 11 80 00 	movl   $0xfec00000,0x80113754
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 54 37 11 80       	mov    0x80113754,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 80 38 11 80 	movzbl 0x80113880,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 f4 80 10 80       	push   $0x801080f4
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 54 37 11 80    	mov    0x80113754,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 54 37 11 80       	mov    0x80113754,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb 08 74 11 80    	cmp    $0x80117408,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 19 2f 00 00       	call   80105260 <memset>

  if(kmem.use_lock)
80102347:	8b 15 94 37 11 80    	mov    0x80113794,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 98 37 11 80       	mov    0x80113798,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 94 37 11 80       	mov    0x80113794,%eax
  kmem.freelist = r;
80102360:	89 1d 98 37 11 80    	mov    %ebx,0x80113798
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 60 37 11 80 	movl   $0x80113760,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 90 2e 00 00       	jmp    80105210 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 60 37 11 80       	push   $0x80113760
80102388:	e8 c3 2d 00 00       	call   80105150 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 26 81 10 80       	push   $0x80108126
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 2c 81 10 80       	push   $0x8010812c
80102400:	68 60 37 11 80       	push   $0x80113760
80102405:	e8 06 2c 00 00       	call   80105010 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 94 37 11 80 00 	movl   $0x0,0x80113794
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 94 37 11 80 01 	movl   $0x1,0x80113794
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 94 37 11 80       	mov    0x80113794,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 98 37 11 80       	mov    0x80113798,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 98 37 11 80    	mov    %edx,0x80113798
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 60 37 11 80       	push   $0x80113760
801024f3:	e8 58 2c 00 00       	call   80105150 <acquire>
  r = kmem.freelist;
801024f8:	a1 98 37 11 80       	mov    0x80113798,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 94 37 11 80    	mov    0x80113794,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 98 37 11 80    	mov    %ecx,0x80113798
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 60 37 11 80       	push   $0x80113760
80102521:	e8 ea 2c 00 00       	call   80105210 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 60 82 10 80 	movzbl -0x7fef7da0(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 60 81 10 80 	movzbl -0x7fef7ea0(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 40 81 10 80 	mov    -0x7fef7ec0(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 60 82 10 80 	movzbl -0x7fef7da0(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 9c 37 11 80       	mov    0x8011379c,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 9c 37 11 80    	mov    0x8011379c,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 9c 37 11 80       	mov    0x8011379c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 9c 37 11 80       	mov    0x8011379c,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 74 29 00 00       	call   801052b0 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d e8 37 11 80    	mov    0x801137e8,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 d4 37 11 80       	mov    0x801137d4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 e4 37 11 80    	pushl  0x801137e4
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d ec 37 11 80 	pushl  -0x7feec814(,%ebx,4)
80102a44:	ff 35 e4 37 11 80    	pushl  0x801137e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 a7 28 00 00       	call   80105310 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d e8 37 11 80    	cmp    %ebx,0x801137e8
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 d4 37 11 80    	pushl  0x801137d4
80102aae:	ff 35 e4 37 11 80    	pushl  0x801137e4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d e8 37 11 80    	mov    0x801137e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a ec 37 11 80    	mov    -0x7feec814(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 60 83 10 80       	push   $0x80108360
80102b0f:	68 a0 37 11 80       	push   $0x801137a0
80102b14:	e8 f7 24 00 00       	call   80105010 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d e4 37 11 80    	mov    %ebx,0x801137e4
  log.size = sb.nlog;
80102b32:	89 15 d8 37 11 80    	mov    %edx,0x801137d8
  log.start = sb.logstart;
80102b38:	a3 d4 37 11 80       	mov    %eax,0x801137d4
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d e8 37 11 80    	mov    %ebx,0x801137e8
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a e8 37 11 80    	mov    %ecx,-0x7feec818(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 e8 37 11 80 00 	movl   $0x0,0x801137e8
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 a0 37 11 80       	push   $0x801137a0
80102bab:	e8 a0 25 00 00       	call   80105150 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 a0 37 11 80       	push   $0x801137a0
80102bc0:	68 a0 37 11 80       	push   $0x801137a0
80102bc5:	e8 b6 1b 00 00       	call   80104780 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 e0 37 11 80       	mov    0x801137e0,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 dc 37 11 80       	mov    0x801137dc,%eax
80102bdb:	8b 15 e8 37 11 80    	mov    0x801137e8,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 dc 37 11 80       	mov    %eax,0x801137dc
      release(&log.lock);
80102bf7:	68 a0 37 11 80       	push   $0x801137a0
80102bfc:	e8 0f 26 00 00       	call   80105210 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 a0 37 11 80       	push   $0x801137a0
80102c1e:	e8 2d 25 00 00       	call   80105150 <acquire>
  log.outstanding -= 1;
80102c23:	a1 dc 37 11 80       	mov    0x801137dc,%eax
  if(log.committing)
80102c28:	8b 35 e0 37 11 80    	mov    0x801137e0,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d dc 37 11 80    	mov    %ebx,0x801137dc
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 e0 37 11 80 01 	movl   $0x1,0x801137e0
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 a0 37 11 80       	push   $0x801137a0
80102c5c:	e8 af 25 00 00       	call   80105210 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d e8 37 11 80    	mov    0x801137e8,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 d4 37 11 80       	mov    0x801137d4,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 e4 37 11 80    	pushl  0x801137e4
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d ec 37 11 80 	pushl  -0x7feec814(,%ebx,4)
80102c96:	ff 35 e4 37 11 80    	pushl  0x801137e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 55 26 00 00       	call   80105310 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d e8 37 11 80    	cmp    0x801137e8,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 e8 37 11 80 00 	movl   $0x0,0x801137e8
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 a0 37 11 80       	push   $0x801137a0
80102cff:	e8 4c 24 00 00       	call   80105150 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
    log.committing = 0;
80102d0b:	c7 05 e0 37 11 80 00 	movl   $0x0,0x801137e0
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 66 1c 00 00       	call   80104980 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
80102d21:	e8 ea 24 00 00       	call   80105210 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 a0 37 11 80       	push   $0x801137a0
80102d40:	e8 3b 1c 00 00       	call   80104980 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
80102d4c:	e8 bf 24 00 00       	call   80105210 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 64 83 10 80       	push   $0x80108364
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 e8 37 11 80    	mov    0x801137e8,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 d8 37 11 80       	mov    0x801137d8,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 dc 37 11 80       	mov    0x801137dc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 a0 37 11 80       	push   $0x801137a0
80102dae:	e8 9d 23 00 00       	call   80105150 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d e8 37 11 80    	mov    0x801137e8,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 ec 37 11 80    	cmp    0x801137ec,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 ec 37 11 80 	cmp    %edx,-0x7feec814(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 ec 37 11 80 	mov    %edx,-0x7feec814(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 e8 37 11 80       	mov    %eax,0x801137e8
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 a0 37 11 80 	movl   $0x801137a0,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 0e 24 00 00       	jmp    80105210 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 ec 37 11 80 	mov    %edx,-0x7feec814(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 ec 37 11 80       	mov    %eax,0x801137ec
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 73 83 10 80       	push   $0x80108373
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 89 83 10 80       	push   $0x80108389
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 b4 0d 00 00       	call   80103c00 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 ad 0d 00 00       	call   80103c00 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 a4 83 10 80       	push   $0x801083a4
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 d9 37 00 00       	call   80106640 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 14 0d 00 00       	call   80103b80 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 f1 12 00 00       	call   80104170 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 45 49 00 00       	call   801077d0 <switchkvm>
  seginit();
80102e8b:	e8 b0 48 00 00       	call   80107740 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 08 74 11 80       	push   $0x80117408
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 da 4d 00 00       	call   80107ca0 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 6b 48 00 00       	call   80107740 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 27 3b 00 00       	call   80106a10 <uartinit>
  pinit();         // process table
80102ee9:	e8 72 0c 00 00       	call   80103b60 <pinit>
	minit();				 // mlfq process
80102eee:	e8 6d 09 00 00       	call   80103860 <minit>
  tvinit();        // trap vectors
80102ef3:	e8 c8 36 00 00       	call   801065c0 <tvinit>
  binit();         // buffer cache
80102ef8:	e8 43 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102efd:	e8 5e de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f02:	e8 f9 f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f07:	83 c4 0c             	add    $0xc,%esp
80102f0a:	68 8a 00 00 00       	push   $0x8a
80102f0f:	68 8c b4 10 80       	push   $0x8010b48c
80102f14:	68 00 70 00 80       	push   $0x80007000
80102f19:	e8 f2 23 00 00       	call   80105310 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f1e:	69 05 20 3e 11 80 b0 	imul   $0xb0,0x80113e20,%eax
80102f25:	00 00 00 
80102f28:	83 c4 10             	add    $0x10,%esp
80102f2b:	05 a0 38 11 80       	add    $0x801138a0,%eax
80102f30:	3d a0 38 11 80       	cmp    $0x801138a0,%eax
80102f35:	76 6c                	jbe    80102fa3 <main+0x103>
80102f37:	bb a0 38 11 80       	mov    $0x801138a0,%ebx
80102f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f40:	e8 3b 0c 00 00       	call   80103b80 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f64:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 20 3e 11 80 b0 	imul   $0xb0,0x80113e20,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 a0 38 11 80       	add    $0x801138a0,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 e6 0d 00 00       	call   80103da0 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 b8 83 10 80       	push   $0x801083b8
80102ff3:	56                   	push   %esi
80102ff4:	e8 b7 22 00 00       	call   801052b0 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 d5 83 10 80       	push   $0x801083d5
801030b1:	56                   	push   %esi
801030b2:	e8 f9 21 00 00       	call   801052b0 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 9c 37 11 80       	mov    %eax,0x8011379c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 fc 83 10 80 	jmp    *-0x7fef7c04(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d 20 3e 11 80    	mov    0x80113e20,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d 20 3e 11 80    	mov    %ecx,0x80113e20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 a0 38 11 80    	mov    %dl,-0x7feec760(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 80 38 11 80    	mov    %dl,0x80113880
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 bd 83 10 80       	push   $0x801083bd
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 dc 83 10 80       	push   $0x801083dc
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 10 84 10 80       	push   $0x80108410
80103300:	50                   	push   %eax
80103301:	e8 0a 1d 00 00       	call   80105010 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 ec 1d 00 00       	call   80105150 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 fc 15 00 00       	call   80104980 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 67 1e 00 00       	jmp    80105210 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 b7 15 00 00       	call   80104980 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 37 1e 00 00       	call   80105210 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 4e 1d 00 00       	call   80105150 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 27 15 00 00       	call   80104980 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 1e 13 00 00       	call   80104780 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 e7 08 00 00       	call   80103d70 <myproc>
80103489:	8b 40 28             	mov    0x28(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 77 1d 00 00       	call   80105210 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 98 14 00 00       	call   80104980 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 20 1d 00 00       	call   80105210 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 3b 1c 00 00       	call   80105150 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 36 12 00 00       	call   80104780 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 02 08 00 00       	call   80103d70 <myproc>
8010356e:	8b 48 28             	mov    0x28(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 8d 1c 00 00       	call   80105210 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 a4 13 00 00       	call   80104980 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 2c 1c 00 00       	call   80105210 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <get_min_pass>:
	return 0;
}

static uint
get_min_pass()
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	83 ec 14             	sub    $0x14,%esp
	// The ptable lock must be held
	if(!holding(&ptable.lock))
80103606:	68 80 41 11 80       	push   $0x80114180
8010360b:	e8 10 1b 00 00       	call   80105120 <holding>
80103610:	83 c4 10             	add    $0x10,%esp
80103613:	85 c0                	test   %eax,%eax
80103615:	74 41                	je     80103658 <get_min_pass+0x58>
		panic("panic in get_min_pass().");
	
	uint min_pass = mlfq_proc.mlfq_pass;
80103617:	a1 58 41 11 80       	mov    0x80114158,%eax
	struct proc* p;
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010361c:	ba b4 41 11 80       	mov    $0x801141b4,%edx
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p->is_stride && p->state == RUNNABLE && p->pass_value < min_pass) {
80103628:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
8010362e:	85 c9                	test   %ecx,%ecx
80103630:	74 16                	je     80103648 <get_min_pass+0x48>
80103632:	83 7a 10 03          	cmpl   $0x3,0x10(%edx)
80103636:	75 10                	jne    80103648 <get_min_pass+0x48>
80103638:	8b 8a 90 00 00 00    	mov    0x90(%edx),%ecx
8010363e:	39 c8                	cmp    %ecx,%eax
80103640:	0f 47 c1             	cmova  %ecx,%eax
80103643:	90                   	nop
80103644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103648:	81 c2 a8 00 00 00    	add    $0xa8,%edx
8010364e:	81 fa b4 6b 11 80    	cmp    $0x80116bb4,%edx
80103654:	72 d2                	jb     80103628 <get_min_pass+0x28>
			min_pass = p->pass_value;
		}
	}
	return min_pass;
}
80103656:	c9                   	leave  
80103657:	c3                   	ret    
		panic("panic in get_min_pass().");
80103658:	83 ec 0c             	sub    $0xc,%esp
8010365b:	68 15 84 10 80       	push   $0x80108415
80103660:	e8 2b cd ff ff       	call   80100390 <panic>
80103665:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103670 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	56                   	push   %esi
80103674:	89 c6                	mov    %eax,%esi
80103676:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103677:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
8010367c:	eb 10                	jmp    8010368e <wakeup1+0x1e>
8010367e:	66 90                	xchg   %ax,%ax
80103680:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
80103686:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
8010368c:	73 5f                	jae    801036ed <wakeup1+0x7d>
    if(p->state == SLEEPING && p->chan == chan){
8010368e:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103692:	75 ec                	jne    80103680 <wakeup1+0x10>
80103694:	39 73 24             	cmp    %esi,0x24(%ebx)
80103697:	75 e7                	jne    80103680 <wakeup1+0x10>
      if (!p->is_stride) {
80103699:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010369f:	85 c0                	test   %eax,%eax
801036a1:	75 55                	jne    801036f8 <wakeup1+0x88>
				enqueue(p->lev, p);
801036a3:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
801036a9:	8d 8a c0 00 00 00    	lea    0xc0(%edx),%ecx
801036af:	8b 04 8d 4c 3e 11 80 	mov    -0x7feec1b4(,%ecx,4),%eax
801036b6:	83 c0 01             	add    $0x1,%eax
801036b9:	83 e0 3f             	and    $0x3f,%eax
	if (is_full(lev))
801036bc:	39 04 8d 40 3e 11 80 	cmp    %eax,-0x7feec1c0(,%ecx,4)
801036c3:	74 40                	je     80103705 <wakeup1+0x95>
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
801036c5:	c1 e2 06             	shl    $0x6,%edx
	mlfq_proc.queue_rear[lev] = ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
801036c8:	89 04 8d 4c 3e 11 80 	mov    %eax,-0x7feec1b4(,%ecx,4)
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
801036cf:	01 d0                	add    %edx,%eax
801036d1:	89 1c 85 40 3e 11 80 	mov    %ebx,-0x7feec1c0(,%eax,4)
			} else {
				p->pass_value = get_min_pass();
			}

			p->state = RUNNABLE;
801036d8:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036df:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
801036e5:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
801036eb:	72 a1                	jb     8010368e <wakeup1+0x1e>
		}
}
801036ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036f0:	5b                   	pop    %ebx
801036f1:	5e                   	pop    %esi
801036f2:	5d                   	pop    %ebp
801036f3:	c3                   	ret    
801036f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				p->pass_value = get_min_pass();
801036f8:	e8 03 ff ff ff       	call   80103600 <get_min_pass>
801036fd:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
80103703:	eb d3                	jmp    801036d8 <wakeup1+0x68>
		panic("Queue is already full");
80103705:	83 ec 0c             	sub    $0xc,%esp
80103708:	68 2e 84 10 80       	push   $0x8010842e
8010370d:	e8 7e cc ff ff       	call   80100390 <panic>
80103712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103720 <allocproc>:
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103724:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
{
80103729:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010372c:	68 80 41 11 80       	push   $0x80114180
80103731:	e8 1a 1a 00 00       	call   80105150 <acquire>
80103736:	83 c4 10             	add    $0x10,%esp
80103739:	eb 17                	jmp    80103752 <allocproc+0x32>
8010373b:	90                   	nop
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103740:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
80103746:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
8010374c:	0f 83 8e 00 00 00    	jae    801037e0 <allocproc+0xc0>
    if(p->state == UNUSED)
80103752:	8b 43 10             	mov    0x10(%ebx),%eax
80103755:	85 c0                	test   %eax,%eax
80103757:	75 e7                	jne    80103740 <allocproc+0x20>
  p->pid = nextpid++;
80103759:	a1 08 b0 10 80       	mov    0x8010b008,%eax
  release(&ptable.lock);
8010375e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103761:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
80103768:	8d 50 01             	lea    0x1(%eax),%edx
8010376b:	89 43 14             	mov    %eax,0x14(%ebx)
  release(&ptable.lock);
8010376e:	68 80 41 11 80       	push   $0x80114180
  p->pid = nextpid++;
80103773:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
  release(&ptable.lock);
80103779:	e8 92 1a 00 00       	call   80105210 <release>
  if((p->kstack = kalloc()) == 0){
8010377e:	e8 3d ed ff ff       	call   801024c0 <kalloc>
80103783:	83 c4 10             	add    $0x10,%esp
80103786:	85 c0                	test   %eax,%eax
80103788:	89 43 0c             	mov    %eax,0xc(%ebx)
8010378b:	74 6c                	je     801037f9 <allocproc+0xd9>
  sp -= sizeof *p->tf;
8010378d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
80103793:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103796:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010379b:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
8010379e:	c7 40 14 af 65 10 80 	movl   $0x801065af,0x14(%eax)
  p->context = (struct context*)sp;
801037a5:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037a8:	6a 14                	push   $0x14
801037aa:	6a 00                	push   $0x0
801037ac:	50                   	push   %eax
801037ad:	e8 ae 1a 00 00       	call   80105260 <memset>
  p->context->eip = (uint)forkret;
801037b2:	8b 43 20             	mov    0x20(%ebx),%eax
  return p;
801037b5:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801037b8:	c7 40 10 10 38 10 80 	movl   $0x80103810,0x10(%eax)
  p->tid = 0;
801037bf:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
801037c6:	00 00 00 
  p->manager = 0;
801037c9:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801037d0:	00 00 00 
}
801037d3:	89 d8                	mov    %ebx,%eax
801037d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037d8:	c9                   	leave  
801037d9:	c3                   	ret    
801037da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801037e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037e3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037e5:	68 80 41 11 80       	push   $0x80114180
801037ea:	e8 21 1a 00 00       	call   80105210 <release>
}
801037ef:	89 d8                	mov    %ebx,%eax
  return 0;
801037f1:	83 c4 10             	add    $0x10,%esp
}
801037f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037f7:	c9                   	leave  
801037f8:	c3                   	ret    
    p->state = UNUSED;
801037f9:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103800:	31 db                	xor    %ebx,%ebx
80103802:	eb cf                	jmp    801037d3 <allocproc+0xb3>
80103804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010380a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103810 <forkret>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103816:	68 80 41 11 80       	push   $0x80114180
8010381b:	e8 f0 19 00 00       	call   80105210 <release>
  if (first) {
80103820:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	85 c0                	test   %eax,%eax
8010382a:	75 04                	jne    80103830 <forkret+0x20>
}
8010382c:	c9                   	leave  
8010382d:	c3                   	ret    
8010382e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103830:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103833:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010383a:	00 00 00 
    iinit(ROOTDEV);
8010383d:	6a 01                	push   $0x1
8010383f:	e8 3c dc ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103844:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010384b:	e8 b0 f2 ff ff       	call   80102b00 <initlog>
80103850:	83 c4 10             	add    $0x10,%esp
}
80103853:	c9                   	leave  
80103854:	c3                   	ret    
80103855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103860 <minit>:
{
80103860:	55                   	push   %ebp
80103861:	b8 40 3e 11 80       	mov    $0x80113e40,%eax
	mlfq_proc.mlfq_pass = 0;
80103866:	c7 05 58 41 11 80 00 	movl   $0x0,0x80114158
8010386d:	00 00 00 
	mlfq_proc.mlfq_ticket = TOTAL_TICKET;	 
80103870:	c7 05 60 41 11 80 64 	movl   $0x64,0x80114160
80103877:	00 00 00 
	mlfq_proc.mlfq_stride = LARGENUM / mlfq_proc.mlfq_ticket; 
8010387a:	c7 05 5c 41 11 80 64 	movl   $0x64,0x8011415c
80103881:	00 00 00 
80103884:	89 c1                	mov    %eax,%ecx
{
80103886:	89 e5                	mov    %esp,%ebp
80103888:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
		mlfq_proc.queue_front[i] = 0;
8010388e:	c7 81 00 03 00 00 00 	movl   $0x0,0x300(%ecx)
80103895:	00 00 00 
		mlfq_proc.queue_rear[i] = 0;
80103898:	c7 81 0c 03 00 00 00 	movl   $0x0,0x30c(%ecx)
8010389f:	00 00 00 
801038a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			mlfq_proc.queue[i][np] = 0;
801038a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801038ae:	83 c0 04             	add    $0x4,%eax
		for (int np = 0; np < NPROC; np++) {
801038b1:	39 d0                	cmp    %edx,%eax
801038b3:	75 f3                	jne    801038a8 <minit+0x48>
801038b5:	83 c1 04             	add    $0x4,%ecx
	for (int i = 0; i < 3; ++i) {
801038b8:	3d 40 41 11 80       	cmp    $0x80114140,%eax
801038bd:	75 c9                	jne    80103888 <minit+0x28>
}
801038bf:	5d                   	pop    %ebp
801038c0:	c3                   	ret    
801038c1:	eb 0d                	jmp    801038d0 <mlfq_pass_inc>
801038c3:	90                   	nop
801038c4:	90                   	nop
801038c5:	90                   	nop
801038c6:	90                   	nop
801038c7:	90                   	nop
801038c8:	90                   	nop
801038c9:	90                   	nop
801038ca:	90                   	nop
801038cb:	90                   	nop
801038cc:	90                   	nop
801038cd:	90                   	nop
801038ce:	90                   	nop
801038cf:	90                   	nop

801038d0 <mlfq_pass_inc>:
{
801038d0:	55                   	push   %ebp
	mlfq_proc.mlfq_pass += mlfq_proc.mlfq_stride;
801038d1:	a1 5c 41 11 80       	mov    0x8011415c,%eax
801038d6:	01 05 58 41 11 80    	add    %eax,0x80114158
{
801038dc:	89 e5                	mov    %esp,%ebp
}
801038de:	5d                   	pop    %ebp
801038df:	c3                   	ret    

801038e0 <priority_boost>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	57                   	push   %edi
801038e4:	56                   	push   %esi
801038e5:	53                   	push   %ebx
801038e6:	83 ec 1c             	sub    $0x1c,%esp
  if (boost_tick < BOOST_LIMIT)
801038e9:	83 3d c0 b5 10 80 63 	cmpl   $0x63,0x8010b5c0
801038f0:	0f 86 44 02 00 00    	jbe    80103b3a <priority_boost+0x25a>
 	int flag = holding(&ptable.lock); 
801038f6:	83 ec 0c             	sub    $0xc,%esp
  boost_tick = 0; 
801038f9:	c7 05 c0 b5 10 80 00 	movl   $0x0,0x8010b5c0
80103900:	00 00 00 
 	int flag = holding(&ptable.lock); 
80103903:	68 80 41 11 80       	push   $0x80114180
80103908:	e8 13 18 00 00       	call   80105120 <holding>
	if (!flag)
8010390d:	83 c4 10             	add    $0x10,%esp
80103910:	85 c0                	test   %eax,%eax
 	int flag = holding(&ptable.lock); 
80103912:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (!flag)
80103915:	0f 84 e5 01 00 00    	je     80103b00 <priority_boost+0x220>
{
8010391b:	b8 b4 41 11 80       	mov    $0x801141b4,%eax
    if (p->is_stride) {
80103920:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80103926:	85 c9                	test   %ecx,%ecx
80103928:	75 1e                	jne    80103948 <priority_boost+0x68>
    if (p->lev == 0)
8010392a:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103930:	85 d2                	test   %edx,%edx
80103932:	74 14                	je     80103948 <priority_boost+0x68>
		p->lev = 0; 
80103934:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010393b:	00 00 00 
    p->tick_cnt = 0; 
8010393e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80103945:	00 00 00 
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103948:	05 a8 00 00 00       	add    $0xa8,%eax
8010394d:	3d b4 6b 11 80       	cmp    $0x80116bb4,%eax
80103952:	72 cc                	jb     80103920 <priority_boost+0x40>
	return mlfq_proc.queue_front[lev] == mlfq_proc.queue_rear[lev];
80103954:	8b 3d 50 41 11 80    	mov    0x80114150,%edi
8010395a:	a1 44 41 11 80       	mov    0x80114144,%eax
	if(is_empty(lev)) {
8010395f:	39 c7                	cmp    %eax,%edi
	return mlfq_proc.queue_front[lev] == mlfq_proc.queue_rear[lev];
80103961:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if(is_empty(lev)) {
80103964:	0f 84 a3 00 00 00    	je     80103a0d <priority_boost+0x12d>
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
8010396a:	83 c0 01             	add    $0x1,%eax
8010396d:	83 e0 3f             	and    $0x3f,%eax
	return mlfq_proc.queue[lev][mlfq_proc.queue_front[lev]];
80103970:	8b 1c 85 40 3f 11 80 	mov    -0x7feec0c0(,%eax,4),%ebx
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
80103977:	a3 44 41 11 80       	mov    %eax,0x80114144
    if (!(p = dequeue(1))) { 
8010397c:	85 db                	test   %ebx,%ebx
8010397e:	0f 84 89 00 00 00    	je     80103a0d <priority_boost+0x12d>
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80103984:	8b 3d 4c 41 11 80    	mov    0x8011414c,%edi
8010398a:	8b 35 40 41 11 80    	mov    0x80114140,%esi
80103990:	8d 4f 01             	lea    0x1(%edi),%ecx
80103993:	83 e1 3f             	and    $0x3f,%ecx
	if (is_full(lev))
80103996:	39 ce                	cmp    %ecx,%esi
80103998:	0f 84 82 01 00 00    	je     80103b20 <priority_boost+0x240>
8010399e:	31 ff                	xor    %edi,%edi
801039a0:	eb 2c                	jmp    801039ce <priority_boost+0xee>
801039a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
801039a8:	83 c0 01             	add    $0x1,%eax
801039ab:	83 e0 3f             	and    $0x3f,%eax
	return mlfq_proc.queue[lev][mlfq_proc.queue_front[lev]];
801039ae:	8b 1c 85 40 3f 11 80 	mov    -0x7feec0c0(,%eax,4),%ebx
    if (!(p = dequeue(1))) { 
801039b5:	85 db                	test   %ebx,%ebx
801039b7:	74 49                	je     80103a02 <priority_boost+0x122>
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
801039b9:	8d 51 01             	lea    0x1(%ecx),%edx
801039bc:	bf 01 00 00 00       	mov    $0x1,%edi
801039c1:	83 e2 3f             	and    $0x3f,%edx
	if (is_full(lev))
801039c4:	39 f2                	cmp    %esi,%edx
801039c6:	0f 84 49 01 00 00    	je     80103b15 <priority_boost+0x235>
801039cc:	89 d1                	mov    %edx,%ecx
	if(is_empty(lev)) {
801039ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
801039d1:	89 1c 8d 40 3e 11 80 	mov    %ebx,-0x7feec1c0(,%ecx,4)
	if(is_empty(lev)) {
801039d8:	75 ce                	jne    801039a8 <priority_boost+0xc8>
801039da:	89 f8                	mov    %edi,%eax
801039dc:	89 0d 4c 41 11 80    	mov    %ecx,0x8011414c
801039e2:	84 c0                	test   %al,%al
801039e4:	74 27                	je     80103a0d <priority_boost+0x12d>
801039e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	return mlfq_proc.queue_front[lev] == mlfq_proc.queue_rear[lev];
801039e9:	8b 35 54 41 11 80    	mov    0x80114154,%esi
801039ef:	a3 44 41 11 80       	mov    %eax,0x80114144
801039f4:	a1 48 41 11 80       	mov    0x80114148,%eax
	if(is_empty(lev)) {
801039f9:	39 f0                	cmp    %esi,%eax
801039fb:	75 23                	jne    80103a20 <priority_boost+0x140>
801039fd:	e9 ab 00 00 00       	jmp    80103aad <priority_boost+0x1cd>
80103a02:	89 0d 4c 41 11 80    	mov    %ecx,0x8011414c
80103a08:	a3 44 41 11 80       	mov    %eax,0x80114144
	return mlfq_proc.queue_front[lev] == mlfq_proc.queue_rear[lev];
80103a0d:	a1 48 41 11 80       	mov    0x80114148,%eax
80103a12:	8b 35 54 41 11 80    	mov    0x80114154,%esi
	if(is_empty(lev)) {
80103a18:	39 f0                	cmp    %esi,%eax
80103a1a:	0f 84 82 00 00 00    	je     80103aa2 <priority_boost+0x1c2>
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
80103a20:	83 c0 01             	add    $0x1,%eax
80103a23:	83 e0 3f             	and    $0x3f,%eax
	return mlfq_proc.queue[lev][mlfq_proc.queue_front[lev]];
80103a26:	8b 1c 85 40 40 11 80 	mov    -0x7feebfc0(,%eax,4),%ebx
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
80103a2d:	a3 48 41 11 80       	mov    %eax,0x80114148
    if (!(p = dequeue(2))) { 
80103a32:	85 db                	test   %ebx,%ebx
80103a34:	0f 84 9d 00 00 00    	je     80103ad7 <priority_boost+0x1f7>
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80103a3a:	8b 0d 4c 41 11 80    	mov    0x8011414c,%ecx
80103a40:	8b 3d 40 41 11 80    	mov    0x80114140,%edi
80103a46:	83 c1 01             	add    $0x1,%ecx
80103a49:	89 7d e0             	mov    %edi,-0x20(%ebp)
80103a4c:	83 e1 3f             	and    $0x3f,%ecx
	if (is_full(lev))
80103a4f:	39 f9                	cmp    %edi,%ecx
80103a51:	0f 84 c9 00 00 00    	je     80103b20 <priority_boost+0x240>
80103a57:	31 ff                	xor    %edi,%edi
80103a59:	eb 2c                	jmp    80103a87 <priority_boost+0x1a7>
80103a5b:	90                   	nop
80103a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
80103a60:	83 c0 01             	add    $0x1,%eax
80103a63:	83 e0 3f             	and    $0x3f,%eax
	return mlfq_proc.queue[lev][mlfq_proc.queue_front[lev]];
80103a66:	8b 1c 85 40 40 11 80 	mov    -0x7feebfc0(,%eax,4),%ebx
    if (!(p = dequeue(2))) { 
80103a6d:	85 db                	test   %ebx,%ebx
80103a6f:	74 5b                	je     80103acc <priority_boost+0x1ec>
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80103a71:	8d 51 01             	lea    0x1(%ecx),%edx
80103a74:	bf 01 00 00 00       	mov    $0x1,%edi
80103a79:	83 e2 3f             	and    $0x3f,%edx
	if (is_full(lev))
80103a7c:	3b 55 e0             	cmp    -0x20(%ebp),%edx
80103a7f:	0f 84 a8 00 00 00    	je     80103b2d <priority_boost+0x24d>
80103a85:	89 d1                	mov    %edx,%ecx
	if(is_empty(lev)) {
80103a87:	39 f0                	cmp    %esi,%eax
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
80103a89:	89 1c 8d 40 3e 11 80 	mov    %ebx,-0x7feec1c0(,%ecx,4)
	if(is_empty(lev)) {
80103a90:	75 ce                	jne    80103a60 <priority_boost+0x180>
80103a92:	89 fb                	mov    %edi,%ebx
80103a94:	84 db                	test   %bl,%bl
80103a96:	0f 85 ab 00 00 00    	jne    80103b47 <priority_boost+0x267>
80103a9c:	89 0d 4c 41 11 80    	mov    %ecx,0x8011414c
	if (mlfq_proc.queue_front[1] != mlfq_proc.queue_rear[1] ||
80103aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103aa5:	3b 05 44 41 11 80    	cmp    0x80114144,%eax
80103aab:	75 3d                	jne    80103aea <priority_boost+0x20a>
	if (!flag)
80103aad:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ab0:	85 c0                	test   %eax,%eax
80103ab2:	75 10                	jne    80103ac4 <priority_boost+0x1e4>
		release(&ptable.lock);
80103ab4:	83 ec 0c             	sub    $0xc,%esp
80103ab7:	68 80 41 11 80       	push   $0x80114180
80103abc:	e8 4f 17 00 00       	call   80105210 <release>
80103ac1:	83 c4 10             	add    $0x10,%esp
}
80103ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ac7:	5b                   	pop    %ebx
80103ac8:	5e                   	pop    %esi
80103ac9:	5f                   	pop    %edi
80103aca:	5d                   	pop    %ebp
80103acb:	c3                   	ret    
80103acc:	a3 48 41 11 80       	mov    %eax,0x80114148
80103ad1:	89 0d 4c 41 11 80    	mov    %ecx,0x8011414c
	if (mlfq_proc.queue_front[1] != mlfq_proc.queue_rear[1] ||
80103ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ada:	39 05 44 41 11 80    	cmp    %eax,0x80114144
80103ae0:	75 08                	jne    80103aea <priority_boost+0x20a>
80103ae2:	39 35 48 41 11 80    	cmp    %esi,0x80114148
80103ae8:	74 c3                	je     80103aad <priority_boost+0x1cd>
		panic("panic in priority boost().");
80103aea:	83 ec 0c             	sub    $0xc,%esp
80103aed:	68 5c 84 10 80       	push   $0x8010845c
80103af2:	e8 99 c8 ff ff       	call   80100390 <panic>
80103af7:	89 f6                	mov    %esi,%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  	acquire(&ptable.lock);
80103b00:	83 ec 0c             	sub    $0xc,%esp
80103b03:	68 80 41 11 80       	push   $0x80114180
80103b08:	e8 43 16 00 00       	call   80105150 <acquire>
80103b0d:	83 c4 10             	add    $0x10,%esp
80103b10:	e9 06 fe ff ff       	jmp    8010391b <priority_boost+0x3b>
80103b15:	89 0d 4c 41 11 80    	mov    %ecx,0x8011414c
80103b1b:	a3 44 41 11 80       	mov    %eax,0x80114144
		panic("Queue is already full");
80103b20:	83 ec 0c             	sub    $0xc,%esp
80103b23:	68 2e 84 10 80       	push   $0x8010842e
80103b28:	e8 63 c8 ff ff       	call   80100390 <panic>
80103b2d:	a3 48 41 11 80       	mov    %eax,0x80114148
80103b32:	89 0d 4c 41 11 80    	mov    %ecx,0x8011414c
80103b38:	eb e6                	jmp    80103b20 <priority_boost+0x240>
    panic("panic in priority boost");
80103b3a:	83 ec 0c             	sub    $0xc,%esp
80103b3d:	68 44 84 10 80       	push   $0x80108444
80103b42:	e8 49 c8 ff ff       	call   80100390 <panic>
80103b47:	a3 48 41 11 80       	mov    %eax,0x80114148
80103b4c:	e9 4b ff ff ff       	jmp    80103a9c <priority_boost+0x1bc>
80103b51:	eb 0d                	jmp    80103b60 <pinit>
80103b53:	90                   	nop
80103b54:	90                   	nop
80103b55:	90                   	nop
80103b56:	90                   	nop
80103b57:	90                   	nop
80103b58:	90                   	nop
80103b59:	90                   	nop
80103b5a:	90                   	nop
80103b5b:	90                   	nop
80103b5c:	90                   	nop
80103b5d:	90                   	nop
80103b5e:	90                   	nop
80103b5f:	90                   	nop

80103b60 <pinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b66:	68 77 84 10 80       	push   $0x80108477
80103b6b:	68 80 41 11 80       	push   $0x80114180
80103b70:	e8 9b 14 00 00       	call   80105010 <initlock>
}
80103b75:	83 c4 10             	add    $0x10,%esp
80103b78:	c9                   	leave  
80103b79:	c3                   	ret    
80103b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b80 <mycpu>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b85:	9c                   	pushf  
80103b86:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b87:	f6 c4 02             	test   $0x2,%ah
80103b8a:	75 5e                	jne    80103bea <mycpu+0x6a>
  apicid = lapicid();
80103b8c:	e8 9f eb ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b91:	8b 35 20 3e 11 80    	mov    0x80113e20,%esi
80103b97:	85 f6                	test   %esi,%esi
80103b99:	7e 42                	jle    80103bdd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b9b:	0f b6 15 a0 38 11 80 	movzbl 0x801138a0,%edx
80103ba2:	39 d0                	cmp    %edx,%eax
80103ba4:	74 30                	je     80103bd6 <mycpu+0x56>
80103ba6:	b9 50 39 11 80       	mov    $0x80113950,%ecx
  for (i = 0; i < ncpu; ++i) {
80103bab:	31 d2                	xor    %edx,%edx
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
80103bb0:	83 c2 01             	add    $0x1,%edx
80103bb3:	39 f2                	cmp    %esi,%edx
80103bb5:	74 26                	je     80103bdd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103bb7:	0f b6 19             	movzbl (%ecx),%ebx
80103bba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103bc0:	39 c3                	cmp    %eax,%ebx
80103bc2:	75 ec                	jne    80103bb0 <mycpu+0x30>
80103bc4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103bca:	05 a0 38 11 80       	add    $0x801138a0,%eax
}
80103bcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bd2:	5b                   	pop    %ebx
80103bd3:	5e                   	pop    %esi
80103bd4:	5d                   	pop    %ebp
80103bd5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103bd6:	b8 a0 38 11 80       	mov    $0x801138a0,%eax
      return &cpus[i];
80103bdb:	eb f2                	jmp    80103bcf <mycpu+0x4f>
  panic("unknown apicid\n");
80103bdd:	83 ec 0c             	sub    $0xc,%esp
80103be0:	68 7e 84 10 80       	push   $0x8010847e
80103be5:	e8 a6 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	68 90 85 10 80       	push   $0x80108590
80103bf2:	e8 99 c7 ff ff       	call   80100390 <panic>
80103bf7:	89 f6                	mov    %esi,%esi
80103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c00 <cpuid>:
cpuid() {
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c06:	e8 75 ff ff ff       	call   80103b80 <mycpu>
80103c0b:	2d a0 38 11 80       	sub    $0x801138a0,%eax
}
80103c10:	c9                   	leave  
  return mycpu()-cpus;
80103c11:	c1 f8 04             	sar    $0x4,%eax
80103c14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c1a:	c3                   	ret    
80103c1b:	90                   	nop
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c20 <getlev>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	53                   	push   %ebx
80103c24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c27:	e8 54 14 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103c2c:	e8 4f ff ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80103c31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c37:	e8 84 14 00 00       	call   801050c0 <popcli>
	return myproc()->lev;
80103c3c:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80103c42:	83 c4 04             	add    $0x4,%esp
80103c45:	5b                   	pop    %ebx
80103c46:	5d                   	pop    %ebp
80103c47:	c3                   	ret    
80103c48:	90                   	nop
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <set_cpu_share>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 0c             	sub    $0xc,%esp
80103c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (ticket + total_stride_ticket > MAX_STRIDE_TICKET)
80103c5c:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80103c61:	01 d8                	add    %ebx,%eax
80103c63:	83 f8 50             	cmp    $0x50,%eax
80103c66:	0f 87 c4 00 00 00    	ja     80103d30 <set_cpu_share+0xe0>
	acquire(&ptable.lock);
80103c6c:	83 ec 0c             	sub    $0xc,%esp
80103c6f:	68 80 41 11 80       	push   $0x80114180
80103c74:	e8 d7 14 00 00       	call   80105150 <acquire>
	if (ticket + total_stride_ticket > MAX_STRIDE_TICKET) {
80103c79:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80103c7e:	83 c4 10             	add    $0x10,%esp
80103c81:	01 d8                	add    %ebx,%eax
80103c83:	83 f8 50             	cmp    $0x50,%eax
80103c86:	0f 87 b4 00 00 00    	ja     80103d40 <set_cpu_share+0xf0>
	p->stride = LARGENUM / ticket;
80103c8c:	be 10 27 00 00       	mov    $0x2710,%esi
  pushcli();
80103c91:	e8 ea 13 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103c96:	e8 e5 fe ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80103c9b:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103ca1:	e8 1a 14 00 00       	call   801050c0 <popcli>
	p->stride = LARGENUM / ticket;
80103ca6:	89 f0                	mov    %esi,%eax
	havestride++;	
80103ca8:	83 05 b8 b5 10 80 01 	addl   $0x1,0x8010b5b8
	total_stride_ticket += ticket;
80103caf:	01 1d bc b5 10 80    	add    %ebx,0x8010b5bc
	p->stride = LARGENUM / ticket;
80103cb5:	99                   	cltd   
	p->lev = -1;
80103cb6:	c7 87 80 00 00 00 ff 	movl   $0xffffffff,0x80(%edi)
80103cbd:	ff ff ff 
	p->tick_cnt = 0;
80103cc0:	c7 87 84 00 00 00 00 	movl   $0x0,0x84(%edi)
80103cc7:	00 00 00 
	p->stride = LARGENUM / ticket;
80103cca:	f7 fb                	idiv   %ebx
	p->is_stride = 1;
80103ccc:	c7 87 88 00 00 00 01 	movl   $0x1,0x88(%edi)
80103cd3:	00 00 00 
	p->ticket = ticket;
80103cd6:	89 9f 94 00 00 00    	mov    %ebx,0x94(%edi)
	p->stride = LARGENUM / ticket;
80103cdc:	89 87 8c 00 00 00    	mov    %eax,0x8c(%edi)
	p->pass_value = get_min_pass();
80103ce2:	e8 19 f9 ff ff       	call   80103600 <get_min_pass>
80103ce7:	89 87 90 00 00 00    	mov    %eax,0x90(%edi)
	mlfq_proc.mlfq_ticket -= ticket;
80103ced:	8b 0d 60 41 11 80    	mov    0x80114160,%ecx
	mlfq_proc.mlfq_stride = LARGENUM / mlfq_proc.mlfq_ticket;
80103cf3:	31 d2                	xor    %edx,%edx
80103cf5:	89 f0                	mov    %esi,%eax
	mlfq_proc.mlfq_ticket -= ticket;
80103cf7:	29 d9                	sub    %ebx,%ecx
	mlfq_proc.mlfq_stride = LARGENUM / mlfq_proc.mlfq_ticket;
80103cf9:	f7 f1                	div    %ecx
	mlfq_proc.mlfq_ticket -= ticket;
80103cfb:	89 0d 60 41 11 80    	mov    %ecx,0x80114160
	if (mlfq_proc.mlfq_ticket + total_stride_ticket != TOTAL_TICKET)
80103d01:	03 0d bc b5 10 80    	add    0x8010b5bc,%ecx
80103d07:	83 f9 64             	cmp    $0x64,%ecx
	mlfq_proc.mlfq_stride = LARGENUM / mlfq_proc.mlfq_ticket;
80103d0a:	a3 5c 41 11 80       	mov    %eax,0x8011415c
	if (mlfq_proc.mlfq_ticket + total_stride_ticket != TOTAL_TICKET)
80103d0f:	75 46                	jne    80103d57 <set_cpu_share+0x107>
	release(&ptable.lock);
80103d11:	83 ec 0c             	sub    $0xc,%esp
80103d14:	68 80 41 11 80       	push   $0x80114180
80103d19:	e8 f2 14 00 00       	call   80105210 <release>
	return 0;
80103d1e:	83 c4 10             	add    $0x10,%esp
80103d21:	31 c0                	xor    %eax,%eax
}
80103d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d26:	5b                   	pop    %ebx
80103d27:	5e                   	pop    %esi
80103d28:	5f                   	pop    %edi
80103d29:	5d                   	pop    %ebp
80103d2a:	c3                   	ret    
80103d2b:	90                   	nop
80103d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return -1;
80103d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d35:	eb ec                	jmp    80103d23 <set_cpu_share+0xd3>
80103d37:	89 f6                	mov    %esi,%esi
80103d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		release(&ptable.lock);
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	68 80 41 11 80       	push   $0x80114180
80103d48:	e8 c3 14 00 00       	call   80105210 <release>
		return -1;
80103d4d:	83 c4 10             	add    $0x10,%esp
80103d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d55:	eb cc                	jmp    80103d23 <set_cpu_share+0xd3>
		panic("panic in set_cpu_share().");
80103d57:	83 ec 0c             	sub    $0xc,%esp
80103d5a:	68 8e 84 10 80       	push   $0x8010848e
80103d5f:	e8 2c c6 ff ff       	call   80100390 <panic>
80103d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d70 <myproc>:
myproc(void) {
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	53                   	push   %ebx
80103d74:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103d77:	e8 04 13 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103d7c:	e8 ff fd ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80103d81:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d87:	e8 34 13 00 00       	call   801050c0 <popcli>
}
80103d8c:	83 c4 04             	add    $0x4,%esp
80103d8f:	89 d8                	mov    %ebx,%eax
80103d91:	5b                   	pop    %ebx
80103d92:	5d                   	pop    %ebp
80103d93:	c3                   	ret    
80103d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103da0 <userinit>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	53                   	push   %ebx
80103da4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103da7:	e8 74 f9 ff ff       	call   80103720 <allocproc>
80103dac:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103dae:	a3 c4 b5 10 80       	mov    %eax,0x8010b5c4
  if((p->pgdir = setupkvm()) == 0)
80103db3:	e8 68 3e 00 00       	call   80107c20 <setupkvm>
80103db8:	85 c0                	test   %eax,%eax
80103dba:	89 43 08             	mov    %eax,0x8(%ebx)
80103dbd:	0f 84 32 01 00 00    	je     80103ef5 <userinit+0x155>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103dc3:	83 ec 04             	sub    $0x4,%esp
80103dc6:	68 2c 00 00 00       	push   $0x2c
80103dcb:	68 60 b4 10 80       	push   $0x8010b460
80103dd0:	50                   	push   %eax
80103dd1:	e8 2a 3b 00 00       	call   80107900 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103dd6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103dd9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ddf:	6a 4c                	push   $0x4c
80103de1:	6a 00                	push   $0x0
80103de3:	ff 73 1c             	pushl  0x1c(%ebx)
80103de6:	e8 75 14 00 00       	call   80105260 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103deb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103dee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103df3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103df8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103dfb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103dff:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e02:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103e06:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e09:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e0d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103e11:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e14:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e18:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103e1c:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e1f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103e26:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e29:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103e30:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e3a:	8d 43 70             	lea    0x70(%ebx),%eax
80103e3d:	6a 10                	push   $0x10
80103e3f:	68 c1 84 10 80       	push   $0x801084c1
80103e44:	50                   	push   %eax
80103e45:	e8 f6 15 00 00       	call   80105440 <safestrcpy>
  p->cwd = namei("/");
80103e4a:	c7 04 24 ca 84 10 80 	movl   $0x801084ca,(%esp)
80103e51:	e8 8a e0 ff ff       	call   80101ee0 <namei>
	p->lev = 0;
80103e56:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103e5d:	00 00 00 
  p->cwd = namei("/");
80103e60:	89 43 6c             	mov    %eax,0x6c(%ebx)
	p->tick_cnt = 0;
80103e63:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103e6a:	00 00 00 
	p->is_stride = 0;
80103e6d:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103e74:	00 00 00 
	p->stride = 0;
80103e77:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103e7e:	00 00 00 
	p->pass_value = 0;
80103e81:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103e88:	00 00 00 
	p->ticket = 0;
80103e8b:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103e92:	00 00 00 
  acquire(&ptable.lock);
80103e95:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80103e9c:	e8 af 12 00 00       	call   80105150 <acquire>
	enqueue(p->lev, p);
80103ea1:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
  p->state = RUNNABLE;
80103ea7:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
	if (is_full(lev))
80103eae:	83 c4 10             	add    $0x10,%esp
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80103eb1:	8d 8a c0 00 00 00    	lea    0xc0(%edx),%ecx
80103eb7:	8b 04 8d 4c 3e 11 80 	mov    -0x7feec1b4(,%ecx,4),%eax
80103ebe:	83 c0 01             	add    $0x1,%eax
80103ec1:	83 e0 3f             	and    $0x3f,%eax
	if (is_full(lev))
80103ec4:	39 04 8d 40 3e 11 80 	cmp    %eax,-0x7feec1c0(,%ecx,4)
80103ecb:	74 35                	je     80103f02 <userinit+0x162>
  release(&ptable.lock);
80103ecd:	83 ec 0c             	sub    $0xc,%esp
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
80103ed0:	c1 e2 06             	shl    $0x6,%edx
	mlfq_proc.queue_rear[lev] = ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80103ed3:	89 04 8d 4c 3e 11 80 	mov    %eax,-0x7feec1b4(,%ecx,4)
  release(&ptable.lock);
80103eda:	68 80 41 11 80       	push   $0x80114180
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
80103edf:	01 d0                	add    %edx,%eax
80103ee1:	89 1c 85 40 3e 11 80 	mov    %ebx,-0x7feec1c0(,%eax,4)
  release(&ptable.lock);
80103ee8:	e8 23 13 00 00       	call   80105210 <release>
}
80103eed:	83 c4 10             	add    $0x10,%esp
80103ef0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef3:	c9                   	leave  
80103ef4:	c3                   	ret    
    panic("userinit: out of memory?");
80103ef5:	83 ec 0c             	sub    $0xc,%esp
80103ef8:	68 a8 84 10 80       	push   $0x801084a8
80103efd:	e8 8e c4 ff ff       	call   80100390 <panic>
		panic("Queue is already full");
80103f02:	83 ec 0c             	sub    $0xc,%esp
80103f05:	68 2e 84 10 80       	push   $0x8010842e
80103f0a:	e8 81 c4 ff ff       	call   80100390 <panic>
80103f0f:	90                   	nop

80103f10 <growproc>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 0c             	sub    $0xc,%esp
80103f19:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80103f1c:	e8 5f 11 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103f21:	e8 5a fc ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80103f26:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f2c:	e8 8f 11 00 00       	call   801050c0 <popcli>
  if(n > 0){
80103f31:	83 ff 00             	cmp    $0x0,%edi
  sz = curproc->sz;
80103f34:	8b 33                	mov    (%ebx),%esi
  if(n > 0){
80103f36:	7f 52                	jg     80103f8a <growproc+0x7a>
  } else if(n < 0){
80103f38:	75 76                	jne    80103fb0 <growproc+0xa0>
  acquire(&ptable.lock);
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 80 41 11 80       	push   $0x80114180
80103f42:	e8 09 12 00 00       	call   80105150 <acquire>
80103f47:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4a:	ba b4 41 11 80       	mov    $0x801141b4,%edx
80103f4f:	90                   	nop
	  if (p->pid == curproc->pid)
80103f50:	8b 43 14             	mov    0x14(%ebx),%eax
80103f53:	39 42 14             	cmp    %eax,0x14(%edx)
80103f56:	75 02                	jne    80103f5a <growproc+0x4a>
		  p->sz = sz;
80103f58:	89 32                	mov    %esi,(%edx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f5a:	81 c2 a8 00 00 00    	add    $0xa8,%edx
80103f60:	81 fa b4 6b 11 80    	cmp    $0x80116bb4,%edx
80103f66:	72 e8                	jb     80103f50 <growproc+0x40>
  release(&ptable.lock);
80103f68:	83 ec 0c             	sub    $0xc,%esp
80103f6b:	68 80 41 11 80       	push   $0x80114180
80103f70:	e8 9b 12 00 00       	call   80105210 <release>
  switchuvm(curproc);
80103f75:	89 1c 24             	mov    %ebx,(%esp)
80103f78:	e8 73 38 00 00       	call   801077f0 <switchuvm>
  return 0;
80103f7d:	83 c4 10             	add    $0x10,%esp
80103f80:	31 c0                	xor    %eax,%eax
}
80103f82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f85:	5b                   	pop    %ebx
80103f86:	5e                   	pop    %esi
80103f87:	5f                   	pop    %edi
80103f88:	5d                   	pop    %ebp
80103f89:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f8a:	83 ec 04             	sub    $0x4,%esp
80103f8d:	01 f7                	add    %esi,%edi
80103f8f:	57                   	push   %edi
80103f90:	56                   	push   %esi
80103f91:	ff 73 08             	pushl  0x8(%ebx)
80103f94:	e8 a7 3a 00 00       	call   80107a40 <allocuvm>
80103f99:	83 c4 10             	add    $0x10,%esp
80103f9c:	85 c0                	test   %eax,%eax
80103f9e:	89 c6                	mov    %eax,%esi
80103fa0:	75 98                	jne    80103f3a <growproc+0x2a>
      return -1;
80103fa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fa7:	eb d9                	jmp    80103f82 <growproc+0x72>
80103fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fb0:	83 ec 04             	sub    $0x4,%esp
80103fb3:	01 f7                	add    %esi,%edi
80103fb5:	57                   	push   %edi
80103fb6:	56                   	push   %esi
80103fb7:	ff 73 08             	pushl  0x8(%ebx)
80103fba:	e8 b1 3b 00 00       	call   80107b70 <deallocuvm>
80103fbf:	83 c4 10             	add    $0x10,%esp
80103fc2:	85 c0                	test   %eax,%eax
80103fc4:	89 c6                	mov    %eax,%esi
80103fc6:	0f 85 6e ff ff ff    	jne    80103f3a <growproc+0x2a>
80103fcc:	eb d4                	jmp    80103fa2 <growproc+0x92>
80103fce:	66 90                	xchg   %ax,%ax

80103fd0 <fork>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103fd9:	e8 a2 10 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103fde:	e8 9d fb ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80103fe3:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103fe9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103fec:	e8 cf 10 00 00       	call   801050c0 <popcli>
  if((np = allocproc()) == 0){
80103ff1:	e8 2a f7 ff ff       	call   80103720 <allocproc>
80103ff6:	85 c0                	test   %eax,%eax
80103ff8:	0f 84 3a 01 00 00    	je     80104138 <fork+0x168>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ffe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104001:	83 ec 08             	sub    $0x8,%esp
80104004:	89 c3                	mov    %eax,%ebx
80104006:	ff 32                	pushl  (%edx)
80104008:	ff 72 08             	pushl  0x8(%edx)
8010400b:	e8 e0 3c 00 00       	call   80107cf0 <copyuvm>
80104010:	83 c4 10             	add    $0x10,%esp
80104013:	85 c0                	test   %eax,%eax
80104015:	89 43 08             	mov    %eax,0x8(%ebx)
80104018:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010401b:	0f 84 1e 01 00 00    	je     8010413f <fork+0x16f>
  np->sz = curproc->sz;
80104021:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80104023:	8b 7b 1c             	mov    0x1c(%ebx),%edi
80104026:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
8010402b:	89 53 18             	mov    %edx,0x18(%ebx)
  np->sz = curproc->sz;
8010402e:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80104030:	8b 72 1c             	mov    0x1c(%edx),%esi
80104033:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104035:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104037:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010403a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80104041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104048:	8b 44 b2 2c          	mov    0x2c(%edx,%esi,4),%eax
8010404c:	85 c0                	test   %eax,%eax
8010404e:	74 16                	je     80104066 <fork+0x96>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104050:	83 ec 0c             	sub    $0xc,%esp
80104053:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104056:	50                   	push   %eax
80104057:	e8 94 cd ff ff       	call   80100df0 <filedup>
8010405c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010405f:	89 44 b3 2c          	mov    %eax,0x2c(%ebx,%esi,4)
80104063:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
80104066:	83 c6 01             	add    $0x1,%esi
80104069:	83 fe 10             	cmp    $0x10,%esi
8010406c:	75 da                	jne    80104048 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010406e:	83 ec 0c             	sub    $0xc,%esp
80104071:	ff 72 6c             	pushl  0x6c(%edx)
80104074:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104077:	e8 d4 d5 ff ff       	call   80101650 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010407c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  np->cwd = idup(curproc->cwd);
8010407f:	89 43 6c             	mov    %eax,0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104082:	8d 43 70             	lea    0x70(%ebx),%eax
80104085:	83 c4 0c             	add    $0xc,%esp
80104088:	6a 10                	push   $0x10
8010408a:	83 c2 70             	add    $0x70,%edx
8010408d:	52                   	push   %edx
8010408e:	50                   	push   %eax
8010408f:	e8 ac 13 00 00       	call   80105440 <safestrcpy>
	np->lev = 0;
80104094:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010409b:	00 00 00 
	np->tick_cnt = 0;
8010409e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801040a5:	00 00 00 
	np->is_stride = 0;
801040a8:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801040af:	00 00 00 
	np->stride = 0;
801040b2:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801040b9:	00 00 00 
	np->pass_value = 0;
801040bc:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801040c3:	00 00 00 
	np->ticket = 0;
801040c6:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801040cd:	00 00 00 
  pid = np->pid;
801040d0:	8b 73 14             	mov    0x14(%ebx),%esi
  acquire(&ptable.lock);
801040d3:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
801040da:	e8 71 10 00 00       	call   80105150 <acquire>
	enqueue(np->lev, np);
801040df:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
  np->state = RUNNABLE;
801040e5:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
	if (is_full(lev))
801040ec:	83 c4 10             	add    $0x10,%esp
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
801040ef:	8d 8a c0 00 00 00    	lea    0xc0(%edx),%ecx
801040f5:	8b 04 8d 4c 3e 11 80 	mov    -0x7feec1b4(,%ecx,4),%eax
801040fc:	83 c0 01             	add    $0x1,%eax
801040ff:	83 e0 3f             	and    $0x3f,%eax
	if (is_full(lev))
80104102:	39 04 8d 40 3e 11 80 	cmp    %eax,-0x7feec1c0(,%ecx,4)
80104109:	74 57                	je     80104162 <fork+0x192>
  release(&ptable.lock);
8010410b:	83 ec 0c             	sub    $0xc,%esp
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
8010410e:	c1 e2 06             	shl    $0x6,%edx
	mlfq_proc.queue_rear[lev] = ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80104111:	89 04 8d 4c 3e 11 80 	mov    %eax,-0x7feec1b4(,%ecx,4)
  release(&ptable.lock);
80104118:	68 80 41 11 80       	push   $0x80114180
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
8010411d:	01 d0                	add    %edx,%eax
8010411f:	89 1c 85 40 3e 11 80 	mov    %ebx,-0x7feec1c0(,%eax,4)
  release(&ptable.lock);
80104126:	e8 e5 10 00 00       	call   80105210 <release>
  return pid;
8010412b:	83 c4 10             	add    $0x10,%esp
}
8010412e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104131:	89 f0                	mov    %esi,%eax
80104133:	5b                   	pop    %ebx
80104134:	5e                   	pop    %esi
80104135:	5f                   	pop    %edi
80104136:	5d                   	pop    %ebp
80104137:	c3                   	ret    
    return -1;
80104138:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010413d:	eb ef                	jmp    8010412e <fork+0x15e>
    kfree(np->kstack);
8010413f:	83 ec 0c             	sub    $0xc,%esp
80104142:	ff 73 0c             	pushl  0xc(%ebx)
    return -1;
80104145:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
8010414a:	e8 c1 e1 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
8010414f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    np->state = UNUSED;
80104156:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
8010415d:	83 c4 10             	add    $0x10,%esp
80104160:	eb cc                	jmp    8010412e <fork+0x15e>
		panic("Queue is already full");
80104162:	83 ec 0c             	sub    $0xc,%esp
80104165:	68 2e 84 10 80       	push   $0x8010842e
8010416a:	e8 21 c2 ff ff       	call   80100390 <panic>
8010416f:	90                   	nop

80104170 <scheduler>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	57                   	push   %edi
80104174:	56                   	push   %esi
80104175:	53                   	push   %ebx
80104176:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104179:	e8 02 fa ff ff       	call   80103b80 <mycpu>
			swtch(&(c->scheduler), p->context);
8010417e:	8d 70 04             	lea    0x4(%eax),%esi
  struct cpu *c = mycpu();
80104181:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80104183:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010418a:	00 00 00 
8010418d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104190:	fb                   	sti    
    acquire(&ptable.lock);
80104191:	83 ec 0c             	sub    $0xc,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104194:	bf b4 41 11 80       	mov    $0x801141b4,%edi
    acquire(&ptable.lock);
80104199:	68 80 41 11 80       	push   $0x80114180
8010419e:	e8 ad 0f 00 00       	call   80105150 <acquire>
		min_pass = get_min_pass();
801041a3:	e8 58 f4 ff ff       	call   80103600 <get_min_pass>
		if (min_pass == mlfq_proc.mlfq_pass) {
801041a8:	8b 15 58 41 11 80    	mov    0x80114158,%edx
801041ae:	83 c4 10             	add    $0x10,%esp
801041b1:	39 c2                	cmp    %eax,%edx
801041b3:	75 1d                	jne    801041d2 <scheduler+0x62>
801041b5:	e9 8e 00 00 00       	jmp    80104248 <scheduler+0xd8>
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041c0:	81 c7 a8 00 00 00    	add    $0xa8,%edi
801041c6:	81 ff b4 6b 11 80    	cmp    $0x80116bb4,%edi
801041cc:	0f 83 53 01 00 00    	jae    80104325 <scheduler+0x1b5>
		if (p->state != RUNNABLE || !p->is_stride || p->pass_value != min_pass)
801041d2:	83 7f 10 03          	cmpl   $0x3,0x10(%edi)
801041d6:	75 e8                	jne    801041c0 <scheduler+0x50>
801041d8:	8b 8f 88 00 00 00    	mov    0x88(%edi),%ecx
801041de:	85 c9                	test   %ecx,%ecx
801041e0:	74 de                	je     801041c0 <scheduler+0x50>
801041e2:	3b 87 90 00 00 00    	cmp    0x90(%edi),%eax
801041e8:	75 d6                	jne    801041c0 <scheduler+0x50>
		if (mlfq_proc.mlfq_pass >= MAX_PASS && min_pass >= MAX_PASS) {
801041ea:	81 fa fe ff ff 0f    	cmp    $0xffffffe,%edx
801041f0:	76 0b                	jbe    801041fd <scheduler+0x8d>
801041f2:	3d fe ff ff 0f       	cmp    $0xffffffe,%eax
801041f7:	0f 87 eb 00 00 00    	ja     801042e8 <scheduler+0x178>
			switchuvm(p);
801041fd:	83 ec 0c             	sub    $0xc,%esp
			c->proc = p;
80104200:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
			switchuvm(p);
80104206:	57                   	push   %edi
80104207:	e8 e4 35 00 00       	call   801077f0 <switchuvm>
			p->state = RUNNING;
8010420c:	c7 47 10 04 00 00 00 	movl   $0x4,0x10(%edi)
			swtch(&(c->scheduler), p->context);
80104213:	58                   	pop    %eax
80104214:	5a                   	pop    %edx
80104215:	ff 77 20             	pushl  0x20(%edi)
80104218:	56                   	push   %esi
80104219:	e8 7d 12 00 00       	call   8010549b <swtch>
			switchkvm();
8010421e:	e8 ad 35 00 00       	call   801077d0 <switchkvm>
			c->proc = 0;
80104223:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010422a:	00 00 00 
    release(&ptable.lock);
8010422d:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80104234:	e8 d7 0f 00 00       	call   80105210 <release>
80104239:	83 c4 10             	add    $0x10,%esp
8010423c:	e9 4f ff ff ff       	jmp    80104190 <scheduler+0x20>
80104241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return mlfq_proc.queue_front[lev] == mlfq_proc.queue_rear[lev];
80104248:	8b 0d 40 41 11 80    	mov    0x80114140,%ecx
	if(is_empty(lev)) {
8010424e:	3b 0d 4c 41 11 80    	cmp    0x8011414c,%ecx
80104254:	74 1b                	je     80104271 <scheduler+0x101>
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
80104256:	83 c1 01             	add    $0x1,%ecx
80104259:	83 e1 3f             	and    $0x3f,%ecx
	return mlfq_proc.queue[lev][mlfq_proc.queue_front[lev]];
8010425c:	8b 3c 8d 40 3e 11 80 	mov    -0x7feec1c0(,%ecx,4),%edi
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
80104263:	89 0d 40 41 11 80    	mov    %ecx,0x80114140
		if (!(p = dequeue(lev))) {
80104269:	85 ff                	test   %edi,%edi
8010426b:	0f 85 79 ff ff ff    	jne    801041ea <scheduler+0x7a>
	return mlfq_proc.queue_front[lev] == mlfq_proc.queue_rear[lev];
80104271:	8b 0d 44 41 11 80    	mov    0x80114144,%ecx
	if(is_empty(lev)) {
80104277:	3b 0d 50 41 11 80    	cmp    0x80114150,%ecx
8010427d:	74 1b                	je     8010429a <scheduler+0x12a>
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
8010427f:	83 c1 01             	add    $0x1,%ecx
80104282:	83 e1 3f             	and    $0x3f,%ecx
	return mlfq_proc.queue[lev][mlfq_proc.queue_front[lev]];
80104285:	8b 3c 8d 40 3f 11 80 	mov    -0x7feec0c0(,%ecx,4),%edi
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
8010428c:	89 0d 44 41 11 80    	mov    %ecx,0x80114144
		if (!(p = dequeue(lev))) {
80104292:	85 ff                	test   %edi,%edi
80104294:	0f 85 50 ff ff ff    	jne    801041ea <scheduler+0x7a>
	return mlfq_proc.queue_front[lev] == mlfq_proc.queue_rear[lev];
8010429a:	8b 0d 48 41 11 80    	mov    0x80114148,%ecx
	if(is_empty(lev)) {
801042a0:	3b 0d 54 41 11 80    	cmp    0x80114154,%ecx
801042a6:	74 1b                	je     801042c3 <scheduler+0x153>
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
801042a8:	83 c1 01             	add    $0x1,%ecx
801042ab:	83 e1 3f             	and    $0x3f,%ecx
	return mlfq_proc.queue[lev][mlfq_proc.queue_front[lev]];
801042ae:	8b 3c 8d 40 40 11 80 	mov    -0x7feebfc0(,%ecx,4),%edi
	mlfq_proc.queue_front[lev] = ((mlfq_proc.queue_front[lev] + 1) % NPROC);
801042b5:	89 0d 48 41 11 80    	mov    %ecx,0x80114148
		if (!(p = dequeue(lev))) {
801042bb:	85 ff                	test   %edi,%edi
801042bd:	0f 85 27 ff ff ff    	jne    801041ea <scheduler+0x7a>
	mlfq_proc.mlfq_pass += mlfq_proc.mlfq_stride;
801042c3:	03 05 5c 41 11 80    	add    0x8011415c,%eax
				release(&ptable.lock);
801042c9:	83 ec 0c             	sub    $0xc,%esp
801042cc:	68 80 41 11 80       	push   $0x80114180
	mlfq_proc.mlfq_pass += mlfq_proc.mlfq_stride;
801042d1:	a3 58 41 11 80       	mov    %eax,0x80114158
				release(&ptable.lock);
801042d6:	e8 35 0f 00 00       	call   80105210 <release>
	asm volatile("hlt");
801042db:	f4                   	hlt    
				continue;
801042dc:	83 c4 10             	add    $0x10,%esp
801042df:	e9 ac fe ff ff       	jmp    80104190 <scheduler+0x20>
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	mlfq_proc.mlfq_pass = 0 ;
801042e8:	c7 05 58 41 11 80 00 	movl   $0x0,0x80114158
801042ef:	00 00 00 
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042f2:	b8 b4 41 11 80       	mov    $0x801141b4,%eax
801042f7:	89 f6                	mov    %esi,%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		if (p->stride)
80104300:	8b 88 8c 00 00 00    	mov    0x8c(%eax),%ecx
80104306:	85 c9                	test   %ecx,%ecx
80104308:	74 0a                	je     80104314 <scheduler+0x1a4>
			p->pass_value = 0;
8010430a:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104311:	00 00 00 
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104314:	05 a8 00 00 00       	add    $0xa8,%eax
80104319:	3d b4 6b 11 80       	cmp    $0x80116bb4,%eax
8010431e:	72 e0                	jb     80104300 <scheduler+0x190>
80104320:	e9 d8 fe ff ff       	jmp    801041fd <scheduler+0x8d>
	panic("panic in find_stride_proc().");
80104325:	83 ec 0c             	sub    $0xc,%esp
80104328:	68 cc 84 10 80       	push   $0x801084cc
8010432d:	e8 5e c0 ff ff       	call   80100390 <panic>
80104332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104340 <sched>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
  pushcli();
80104345:	e8 36 0d 00 00       	call   80105080 <pushcli>
  c = mycpu();
8010434a:	e8 31 f8 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
8010434f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104355:	e8 66 0d 00 00       	call   801050c0 <popcli>
  if(!holding(&ptable.lock))
8010435a:	83 ec 0c             	sub    $0xc,%esp
8010435d:	68 80 41 11 80       	push   $0x80114180
80104362:	e8 b9 0d 00 00       	call   80105120 <holding>
80104367:	83 c4 10             	add    $0x10,%esp
8010436a:	85 c0                	test   %eax,%eax
8010436c:	74 4f                	je     801043bd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010436e:	e8 0d f8 ff ff       	call   80103b80 <mycpu>
80104373:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010437a:	75 68                	jne    801043e4 <sched+0xa4>
  if(p->state == RUNNING)
8010437c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80104380:	74 55                	je     801043d7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104382:	9c                   	pushf  
80104383:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104384:	f6 c4 02             	test   $0x2,%ah
80104387:	75 41                	jne    801043ca <sched+0x8a>
  intena = mycpu()->intena;
80104389:	e8 f2 f7 ff ff       	call   80103b80 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010438e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80104391:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104397:	e8 e4 f7 ff ff       	call   80103b80 <mycpu>
8010439c:	83 ec 08             	sub    $0x8,%esp
8010439f:	ff 70 04             	pushl  0x4(%eax)
801043a2:	53                   	push   %ebx
801043a3:	e8 f3 10 00 00       	call   8010549b <swtch>
  mycpu()->intena = intena;
801043a8:	e8 d3 f7 ff ff       	call   80103b80 <mycpu>
}
801043ad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801043b0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801043b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043b9:	5b                   	pop    %ebx
801043ba:	5e                   	pop    %esi
801043bb:	5d                   	pop    %ebp
801043bc:	c3                   	ret    
    panic("sched ptable.lock");
801043bd:	83 ec 0c             	sub    $0xc,%esp
801043c0:	68 e9 84 10 80       	push   $0x801084e9
801043c5:	e8 c6 bf ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801043ca:	83 ec 0c             	sub    $0xc,%esp
801043cd:	68 15 85 10 80       	push   $0x80108515
801043d2:	e8 b9 bf ff ff       	call   80100390 <panic>
    panic("sched running");
801043d7:	83 ec 0c             	sub    $0xc,%esp
801043da:	68 07 85 10 80       	push   $0x80108507
801043df:	e8 ac bf ff ff       	call   80100390 <panic>
    panic("sched locks");
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	68 fb 84 10 80       	push   $0x801084fb
801043ec:	e8 9f bf ff ff       	call   80100390 <panic>
801043f1:	eb 0d                	jmp    80104400 <yield>
801043f3:	90                   	nop
801043f4:	90                   	nop
801043f5:	90                   	nop
801043f6:	90                   	nop
801043f7:	90                   	nop
801043f8:	90                   	nop
801043f9:	90                   	nop
801043fa:	90                   	nop
801043fb:	90                   	nop
801043fc:	90                   	nop
801043fd:	90                   	nop
801043fe:	90                   	nop
801043ff:	90                   	nop

80104400 <yield>:
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104407:	68 80 41 11 80       	push   $0x80114180
8010440c:	e8 3f 0d 00 00       	call   80105150 <acquire>
  pushcli();
80104411:	e8 6a 0c 00 00       	call   80105080 <pushcli>
  c = mycpu();
80104416:	e8 65 f7 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
8010441b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104421:	e8 9a 0c 00 00       	call   801050c0 <popcli>
  myproc()->state = RUNNABLE;
80104426:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  pushcli();
8010442d:	e8 4e 0c 00 00       	call   80105080 <pushcli>
  c = mycpu();
80104432:	e8 49 f7 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80104437:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010443d:	e8 7e 0c 00 00       	call   801050c0 <popcli>
	boost_tick += 1;
80104442:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
	if (boost_tick >= BOOST_LIMIT) {
80104447:	83 c4 10             	add    $0x10,%esp
	boost_tick += 1;
8010444a:	83 c0 01             	add    $0x1,%eax
	if (boost_tick >= BOOST_LIMIT) {
8010444d:	83 f8 63             	cmp    $0x63,%eax
	boost_tick += 1;
80104450:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
	if (boost_tick >= BOOST_LIMIT) {
80104455:	0f 87 a5 00 00 00    	ja     80104500 <yield+0x100>
	p->tick_cnt += 1;
8010445b:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80104461:	8d 50 01             	lea    0x1(%eax),%edx
	if (p->is_stride) {
80104464:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
	p->tick_cnt += 1;
8010446a:	89 93 84 00 00 00    	mov    %edx,0x84(%ebx)
	if (p->is_stride) {
80104470:	85 c0                	test   %eax,%eax
80104472:	75 7c                	jne    801044f0 <yield+0xf0>
		if (p->lev < MAX_MLFQ_LEV - 1 && p->tick_cnt >= TIME_ALLOTMENT[p->lev]) {
80104474:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010447a:	83 f8 01             	cmp    $0x1,%eax
8010447d:	0f 8e 8d 00 00 00    	jle    80104510 <yield+0x110>
		} else if (p->lev == MAX_MLFQ_LEV - 1 && p->tick_cnt >= TIME_QUANTUM[p->lev]) {
80104483:	83 f8 02             	cmp    $0x2,%eax
80104486:	75 09                	jne    80104491 <yield+0x91>
80104488:	83 fa 03             	cmp    $0x3,%edx
8010448b:	0f 87 a7 00 00 00    	ja     80104538 <yield+0x138>
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80104491:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
80104497:	8b 14 8d 4c 3e 11 80 	mov    -0x7feec1b4(,%ecx,4),%edx
8010449e:	83 c2 01             	add    $0x1,%edx
801044a1:	83 e2 3f             	and    $0x3f,%edx
	if (is_full(lev))
801044a4:	39 14 8d 40 3e 11 80 	cmp    %edx,-0x7feec1c0(,%ecx,4)
801044ab:	0f 84 96 00 00 00    	je     80104547 <yield+0x147>
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
801044b1:	c1 e0 06             	shl    $0x6,%eax
	mlfq_proc.queue_rear[lev] = ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
801044b4:	89 14 8d 4c 3e 11 80 	mov    %edx,-0x7feec1b4(,%ecx,4)
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
801044bb:	01 d0                	add    %edx,%eax
801044bd:	89 1c 85 40 3e 11 80 	mov    %ebx,-0x7feec1c0(,%eax,4)
	mlfq_proc.mlfq_pass += mlfq_proc.mlfq_stride;
801044c4:	a1 5c 41 11 80       	mov    0x8011415c,%eax
801044c9:	01 05 58 41 11 80    	add    %eax,0x80114158
  sched();
801044cf:	e8 6c fe ff ff       	call   80104340 <sched>
  release(&ptable.lock);
801044d4:	83 ec 0c             	sub    $0xc,%esp
801044d7:	68 80 41 11 80       	push   $0x80114180
801044dc:	e8 2f 0d 00 00       	call   80105210 <release>
}
801044e1:	31 c0                	xor    %eax,%eax
801044e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e6:	c9                   	leave  
801044e7:	c3                   	ret    
801044e8:	90                   	nop
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		p->pass_value += p->stride;
801044f0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801044f6:	01 83 90 00 00 00    	add    %eax,0x90(%ebx)
801044fc:	eb d1                	jmp    801044cf <yield+0xcf>
801044fe:	66 90                	xchg   %ax,%ax
		priority_boost();
80104500:	e8 db f3 ff ff       	call   801038e0 <priority_boost>
80104505:	e9 51 ff ff ff       	jmp    8010445b <yield+0x5b>
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (p->lev < MAX_MLFQ_LEV - 1 && p->tick_cnt >= TIME_ALLOTMENT[p->lev]) {
80104510:	3b 14 85 00 86 10 80 	cmp    -0x7fef7a00(,%eax,4),%edx
80104517:	0f 82 74 ff ff ff    	jb     80104491 <yield+0x91>
			p->lev++;
8010451d:	83 c0 01             	add    $0x1,%eax
			p->tick_cnt = 0;
80104520:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104527:	00 00 00 
			p->lev++;
8010452a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
			p->tick_cnt = 0;
80104530:	e9 5c ff ff ff       	jmp    80104491 <yield+0x91>
80104535:	8d 76 00             	lea    0x0(%esi),%esi
			p->tick_cnt = 0;
80104538:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010453f:	00 00 00 
80104542:	e9 4a ff ff ff       	jmp    80104491 <yield+0x91>
		panic("Queue is already full");
80104547:	83 ec 0c             	sub    $0xc,%esp
8010454a:	68 2e 84 10 80       	push   $0x8010842e
8010454f:	e8 3c be ff ff       	call   80100390 <panic>
80104554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010455a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104560 <exit>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	56                   	push   %esi
80104565:	53                   	push   %ebx
80104566:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104569:	e8 12 0b 00 00       	call   80105080 <pushcli>
  c = mycpu();
8010456e:	e8 0d f6 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80104573:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104579:	e8 42 0b 00 00       	call   801050c0 <popcli>
  if(curproc == initproc)
8010457e:	39 35 c4 b5 10 80    	cmp    %esi,0x8010b5c4
80104584:	8d 5e 2c             	lea    0x2c(%esi),%ebx
80104587:	8d 7e 6c             	lea    0x6c(%esi),%edi
8010458a:	0f 84 e8 00 00 00    	je     80104678 <exit+0x118>
    if(curproc->ofile[fd]){
80104590:	8b 03                	mov    (%ebx),%eax
80104592:	85 c0                	test   %eax,%eax
80104594:	74 12                	je     801045a8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	50                   	push   %eax
8010459a:	e8 a1 c8 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
8010459f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801045a5:	83 c4 10             	add    $0x10,%esp
801045a8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801045ab:	39 df                	cmp    %ebx,%edi
801045ad:	75 e1                	jne    80104590 <exit+0x30>
  begin_op();
801045af:	e8 ec e5 ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	ff 76 6c             	pushl  0x6c(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045ba:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
  iput(curproc->cwd);
801045bf:	e8 ec d1 ff ff       	call   801017b0 <iput>
  end_op();
801045c4:	e8 47 e6 ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
801045c9:	c7 46 6c 00 00 00 00 	movl   $0x0,0x6c(%esi)
  acquire(&ptable.lock);
801045d0:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
801045d7:	e8 74 0b 00 00       	call   80105150 <acquire>
  wakeup1(curproc->parent);
801045dc:	8b 46 18             	mov    0x18(%esi),%eax
801045df:	e8 8c f0 ff ff       	call   80103670 <wakeup1>
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	eb 15                	jmp    801045fe <exit+0x9e>
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f0:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
801045f6:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
801045fc:	73 2a                	jae    80104628 <exit+0xc8>
    if(p->parent == curproc){
801045fe:	39 73 18             	cmp    %esi,0x18(%ebx)
80104601:	75 ed                	jne    801045f0 <exit+0x90>
      if(p->state == ZOMBIE)
80104603:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
      p->parent = initproc;
80104607:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
8010460c:	89 43 18             	mov    %eax,0x18(%ebx)
      if(p->state == ZOMBIE)
8010460f:	75 df                	jne    801045f0 <exit+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104611:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
        wakeup1(initproc);
80104617:	e8 54 f0 ff ff       	call   80103670 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010461c:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
80104622:	72 da                	jb     801045fe <exit+0x9e>
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (curproc->is_stride) {
80104628:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
8010462e:	85 c0                	test   %eax,%eax
80104630:	74 2d                	je     8010465f <exit+0xff>
		total_stride_ticket -= curproc->ticket;
80104632:	8b 8e 94 00 00 00    	mov    0x94(%esi),%ecx
80104638:	29 0d bc b5 10 80    	sub    %ecx,0x8010b5bc
		mlfq_proc.mlfq_stride = LARGENUM / mlfq_proc.mlfq_ticket;
8010463e:	b8 10 27 00 00       	mov    $0x2710,%eax
		mlfq_proc.mlfq_ticket += curproc->ticket;
80104643:	03 0d 60 41 11 80    	add    0x80114160,%ecx
		mlfq_proc.mlfq_stride = LARGENUM / mlfq_proc.mlfq_ticket;
80104649:	31 d2                	xor    %edx,%edx
		havestride--;
8010464b:	83 2d b8 b5 10 80 01 	subl   $0x1,0x8010b5b8
		mlfq_proc.mlfq_stride = LARGENUM / mlfq_proc.mlfq_ticket;
80104652:	f7 f1                	div    %ecx
		mlfq_proc.mlfq_ticket += curproc->ticket;
80104654:	89 0d 60 41 11 80    	mov    %ecx,0x80114160
		mlfq_proc.mlfq_stride = LARGENUM / mlfq_proc.mlfq_ticket;
8010465a:	a3 5c 41 11 80       	mov    %eax,0x8011415c
  curproc->state = ZOMBIE;
8010465f:	c7 46 10 05 00 00 00 	movl   $0x5,0x10(%esi)
  sched();
80104666:	e8 d5 fc ff ff       	call   80104340 <sched>
  panic("zombie exit");
8010466b:	83 ec 0c             	sub    $0xc,%esp
8010466e:	68 36 85 10 80       	push   $0x80108536
80104673:	e8 18 bd ff ff       	call   80100390 <panic>
    panic("init exiting");
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	68 29 85 10 80       	push   $0x80108529
80104680:	e8 0b bd ff ff       	call   80100390 <panic>
80104685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104690 <tick_yield>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80104695:	83 ec 0c             	sub    $0xc,%esp
80104698:	68 80 41 11 80       	push   $0x80114180
8010469d:	e8 ae 0a 00 00       	call   80105150 <acquire>
  pushcli();
801046a2:	e8 d9 09 00 00       	call   80105080 <pushcli>
  c = mycpu();
801046a7:	e8 d4 f4 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
801046ac:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046b2:	e8 09 0a 00 00       	call   801050c0 <popcli>
  pushcli();
801046b7:	e8 c4 09 00 00       	call   80105080 <pushcli>
  c = mycpu();
801046bc:	e8 bf f4 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
801046c1:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046c7:	e8 f4 09 00 00       	call   801050c0 <popcli>
	if (!p->is_stride) {
801046cc:	83 c4 10             	add    $0x10,%esp
	myproc()->state = RUNNABLE;
801046cf:	c7 46 10 03 00 00 00 	movl   $0x3,0x10(%esi)
	if (!p->is_stride) {
801046d6:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801046dc:	85 c0                	test   %eax,%eax
801046de:	75 49                	jne    80104729 <tick_yield+0x99>
		if (p->lev < MAX_MLFQ_LEV - 1 && p->tick_cnt >= TIME_ALLOTMENT[p->lev]) {
801046e0:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801046e6:	83 f8 01             	cmp    $0x1,%eax
801046e9:	7e 5d                	jle    80104748 <tick_yield+0xb8>
		} else if (p->lev == MAX_MLFQ_LEV - 1) {
801046eb:	83 f8 02             	cmp    $0x2,%eax
801046ee:	75 0a                	jne    801046fa <tick_yield+0x6a>
			p->tick_cnt = 0;
801046f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801046f7:	00 00 00 
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
801046fa:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
80104700:	8b 34 8d 4c 3e 11 80 	mov    -0x7feec1b4(,%ecx,4),%esi
80104707:	8d 56 01             	lea    0x1(%esi),%edx
8010470a:	83 e2 3f             	and    $0x3f,%edx
	if (is_full(lev))
8010470d:	39 14 8d 40 3e 11 80 	cmp    %edx,-0x7feec1c0(,%ecx,4)
80104714:	74 56                	je     8010476c <tick_yield+0xdc>
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
80104716:	c1 e0 06             	shl    $0x6,%eax
	mlfq_proc.queue_rear[lev] = ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80104719:	89 14 8d 4c 3e 11 80 	mov    %edx,-0x7feec1b4(,%ecx,4)
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
80104720:	01 d0                	add    %edx,%eax
80104722:	89 1c 85 40 3e 11 80 	mov    %ebx,-0x7feec1c0(,%eax,4)
  sched();
80104729:	e8 12 fc ff ff       	call   80104340 <sched>
  release(&ptable.lock);
8010472e:	83 ec 0c             	sub    $0xc,%esp
80104731:	68 80 41 11 80       	push   $0x80114180
80104736:	e8 d5 0a 00 00       	call   80105210 <release>
}
8010473b:	83 c4 10             	add    $0x10,%esp
8010473e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104741:	5b                   	pop    %ebx
80104742:	5e                   	pop    %esi
80104743:	5d                   	pop    %ebp
80104744:	c3                   	ret    
80104745:	8d 76 00             	lea    0x0(%esi),%esi
		if (p->lev < MAX_MLFQ_LEV - 1 && p->tick_cnt >= TIME_ALLOTMENT[p->lev]) {
80104748:	8b 0c 85 00 86 10 80 	mov    -0x7fef7a00(,%eax,4),%ecx
8010474f:	39 8b 84 00 00 00    	cmp    %ecx,0x84(%ebx)
80104755:	72 a3                	jb     801046fa <tick_yield+0x6a>
			p->lev++;
80104757:	83 c0 01             	add    $0x1,%eax
			p->tick_cnt = 0;
8010475a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104761:	00 00 00 
			p->lev++;
80104764:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
			p->tick_cnt = 0;
8010476a:	eb 8e                	jmp    801046fa <tick_yield+0x6a>
		panic("Queue is already full");
8010476c:	83 ec 0c             	sub    $0xc,%esp
8010476f:	68 2e 84 10 80       	push   $0x8010842e
80104774:	e8 17 bc ff ff       	call   80100390 <panic>
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104780 <sleep>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	56                   	push   %esi
80104785:	53                   	push   %ebx
80104786:	83 ec 0c             	sub    $0xc,%esp
80104789:	8b 7d 08             	mov    0x8(%ebp),%edi
8010478c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010478f:	e8 ec 08 00 00       	call   80105080 <pushcli>
  c = mycpu();
80104794:	e8 e7 f3 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80104799:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010479f:	e8 1c 09 00 00       	call   801050c0 <popcli>
  if(p == 0)
801047a4:	85 db                	test   %ebx,%ebx
801047a6:	0f 84 87 00 00 00    	je     80104833 <sleep+0xb3>
  if(lk == 0)
801047ac:	85 f6                	test   %esi,%esi
801047ae:	74 76                	je     80104826 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801047b0:	81 fe 80 41 11 80    	cmp    $0x80114180,%esi
801047b6:	74 50                	je     80104808 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801047b8:	83 ec 0c             	sub    $0xc,%esp
801047bb:	68 80 41 11 80       	push   $0x80114180
801047c0:	e8 8b 09 00 00       	call   80105150 <acquire>
    release(lk);
801047c5:	89 34 24             	mov    %esi,(%esp)
801047c8:	e8 43 0a 00 00       	call   80105210 <release>
  p->chan = chan;
801047cd:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801047d0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801047d7:	e8 64 fb ff ff       	call   80104340 <sched>
  p->chan = 0;
801047dc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
801047e3:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
801047ea:	e8 21 0a 00 00       	call   80105210 <release>
    acquire(lk);
801047ef:	89 75 08             	mov    %esi,0x8(%ebp)
801047f2:	83 c4 10             	add    $0x10,%esp
}
801047f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047f8:	5b                   	pop    %ebx
801047f9:	5e                   	pop    %esi
801047fa:	5f                   	pop    %edi
801047fb:	5d                   	pop    %ebp
    acquire(lk);
801047fc:	e9 4f 09 00 00       	jmp    80105150 <acquire>
80104801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104808:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010480b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104812:	e8 29 fb ff ff       	call   80104340 <sched>
  p->chan = 0;
80104817:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010481e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104821:	5b                   	pop    %ebx
80104822:	5e                   	pop    %esi
80104823:	5f                   	pop    %edi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
    panic("sleep without lk");
80104826:	83 ec 0c             	sub    $0xc,%esp
80104829:	68 48 85 10 80       	push   $0x80108548
8010482e:	e8 5d bb ff ff       	call   80100390 <panic>
    panic("sleep");
80104833:	83 ec 0c             	sub    $0xc,%esp
80104836:	68 42 85 10 80       	push   $0x80108542
8010483b:	e8 50 bb ff ff       	call   80100390 <panic>

80104840 <wait>:
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
  pushcli();
80104845:	e8 36 08 00 00       	call   80105080 <pushcli>
  c = mycpu();
8010484a:	e8 31 f3 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
8010484f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104855:	e8 66 08 00 00       	call   801050c0 <popcli>
  acquire(&ptable.lock);
8010485a:	83 ec 0c             	sub    $0xc,%esp
8010485d:	68 80 41 11 80       	push   $0x80114180
80104862:	e8 e9 08 00 00       	call   80105150 <acquire>
80104867:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010486a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010486c:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
80104871:	eb 13                	jmp    80104886 <wait+0x46>
80104873:	90                   	nop
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104878:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
8010487e:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
80104884:	73 1e                	jae    801048a4 <wait+0x64>
      if(p->parent != curproc)
80104886:	39 73 18             	cmp    %esi,0x18(%ebx)
80104889:	75 ed                	jne    80104878 <wait+0x38>
      if(p->state == ZOMBIE){
8010488b:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010488f:	74 3f                	je     801048d0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104891:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
      havekids = 1;
80104897:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010489c:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
801048a2:	72 e2                	jb     80104886 <wait+0x46>
    if(!havekids || curproc->killed){
801048a4:	85 c0                	test   %eax,%eax
801048a6:	0f 84 b6 00 00 00    	je     80104962 <wait+0x122>
801048ac:	8b 46 28             	mov    0x28(%esi),%eax
801048af:	85 c0                	test   %eax,%eax
801048b1:	0f 85 ab 00 00 00    	jne    80104962 <wait+0x122>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801048b7:	83 ec 08             	sub    $0x8,%esp
801048ba:	68 80 41 11 80       	push   $0x80114180
801048bf:	56                   	push   %esi
801048c0:	e8 bb fe ff ff       	call   80104780 <sleep>
    havekids = 0;
801048c5:	83 c4 10             	add    $0x10,%esp
801048c8:	eb a0                	jmp    8010486a <wait+0x2a>
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801048d0:	83 ec 0c             	sub    $0xc,%esp
801048d3:	ff 73 0c             	pushl  0xc(%ebx)
        pid = p->pid;
801048d6:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
801048d9:	e8 32 da ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
801048de:	5a                   	pop    %edx
801048df:	ff 73 08             	pushl  0x8(%ebx)
        p->kstack = 0;
801048e2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
801048e9:	e8 b2 32 00 00       	call   80107ba0 <freevm>
        release(&ptable.lock);
801048ee:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
        p->pid = 0;
801048f5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801048fc:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
80104903:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104907:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
				p->lev = 0;
8010490e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104915:	00 00 00 
				p->tick_cnt = 0;
80104918:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010491f:	00 00 00 
				p->is_stride = 0;
80104922:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80104929:	00 00 00 
				p->stride = 0;
8010492c:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80104933:	00 00 00 
				p->pass_value = 0;
80104936:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
8010493d:	00 00 00 
				p->ticket = 0;
80104940:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80104947:	00 00 00 
        p->state = UNUSED;
8010494a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
80104951:	e8 ba 08 00 00       	call   80105210 <release>
        return pid;
80104956:	83 c4 10             	add    $0x10,%esp
}
80104959:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010495c:	89 f0                	mov    %esi,%eax
8010495e:	5b                   	pop    %ebx
8010495f:	5e                   	pop    %esi
80104960:	5d                   	pop    %ebp
80104961:	c3                   	ret    
      release(&ptable.lock);
80104962:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104965:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010496a:	68 80 41 11 80       	push   $0x80114180
8010496f:	e8 9c 08 00 00       	call   80105210 <release>
      return -1;
80104974:	83 c4 10             	add    $0x10,%esp
80104977:	eb e0                	jmp    80104959 <wait+0x119>
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104980 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 10             	sub    $0x10,%esp
80104987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010498a:	68 80 41 11 80       	push   $0x80114180
8010498f:	e8 bc 07 00 00       	call   80105150 <acquire>
  wakeup1(chan);
80104994:	89 d8                	mov    %ebx,%eax
80104996:	e8 d5 ec ff ff       	call   80103670 <wakeup1>
  release(&ptable.lock);
8010499b:	83 c4 10             	add    $0x10,%esp
8010499e:	c7 45 08 80 41 11 80 	movl   $0x80114180,0x8(%ebp)
}
801049a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a8:	c9                   	leave  
  release(&ptable.lock);
801049a9:	e9 62 08 00 00       	jmp    80105210 <release>
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b8:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
  acquire(&ptable.lock);
801049bd:	83 ec 0c             	sub    $0xc,%esp
801049c0:	68 80 41 11 80       	push   $0x80114180
801049c5:	e8 86 07 00 00       	call   80105150 <acquire>
801049ca:	83 c4 10             	add    $0x10,%esp
801049cd:	eb 0f                	jmp    801049de <kill+0x2e>
801049cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049d0:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
801049d6:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
801049dc:	73 72                	jae    80104a50 <kill+0xa0>
    if(p->pid == pid){
801049de:	39 73 14             	cmp    %esi,0x14(%ebx)
801049e1:	75 ed                	jne    801049d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING) {
801049e3:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
      p->killed = 1;
801049e7:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
      if(p->state == SLEEPING) {
801049ee:	75 46                	jne    80104a36 <kill+0x86>
				if (!p->is_stride) {
801049f0:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801049f6:	85 c0                	test   %eax,%eax
801049f8:	75 76                	jne    80104a70 <kill+0xc0>
					enqueue(p->lev, p);
801049fa:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
	return mlfq_proc.queue_front[lev] == ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80104a00:	8d 8a c0 00 00 00    	lea    0xc0(%edx),%ecx
80104a06:	8b 04 8d 4c 3e 11 80 	mov    -0x7feec1b4(,%ecx,4),%eax
80104a0d:	83 c0 01             	add    $0x1,%eax
80104a10:	83 e0 3f             	and    $0x3f,%eax
	if (is_full(lev))
80104a13:	39 04 8d 40 3e 11 80 	cmp    %eax,-0x7feec1c0(,%ecx,4)
80104a1a:	74 61                	je     80104a7d <kill+0xcd>
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
80104a1c:	c1 e2 06             	shl    $0x6,%edx
	mlfq_proc.queue_rear[lev] = ((mlfq_proc.queue_rear[lev] + 1) % NPROC);
80104a1f:	89 04 8d 4c 3e 11 80 	mov    %eax,-0x7feec1b4(,%ecx,4)
	mlfq_proc.queue[lev][mlfq_proc.queue_rear[lev]] = proc;
80104a26:	01 d0                	add    %edx,%eax
80104a28:	89 1c 85 40 3e 11 80 	mov    %ebx,-0x7feec1c0(,%eax,4)
				} else {
					p->pass_value = get_min_pass();
				}
        p->state = RUNNABLE;
80104a2f:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
			}
      release(&ptable.lock);
80104a36:	83 ec 0c             	sub    $0xc,%esp
80104a39:	68 80 41 11 80       	push   $0x80114180
80104a3e:	e8 cd 07 00 00       	call   80105210 <release>
      return 0;
80104a43:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
80104a46:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 0;
80104a49:	31 c0                	xor    %eax,%eax
}
80104a4b:	5b                   	pop    %ebx
80104a4c:	5e                   	pop    %esi
80104a4d:	5d                   	pop    %ebp
80104a4e:	c3                   	ret    
80104a4f:	90                   	nop
  release(&ptable.lock);
80104a50:	83 ec 0c             	sub    $0xc,%esp
80104a53:	68 80 41 11 80       	push   $0x80114180
80104a58:	e8 b3 07 00 00       	call   80105210 <release>
  return -1;
80104a5d:	83 c4 10             	add    $0x10,%esp
}
80104a60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
80104a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a68:	5b                   	pop    %ebx
80104a69:	5e                   	pop    %esi
80104a6a:	5d                   	pop    %ebp
80104a6b:	c3                   	ret    
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					p->pass_value = get_min_pass();
80104a70:	e8 8b eb ff ff       	call   80103600 <get_min_pass>
80104a75:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
80104a7b:	eb b2                	jmp    80104a2f <kill+0x7f>
		panic("Queue is already full");
80104a7d:	83 ec 0c             	sub    $0xc,%esp
80104a80:	68 2e 84 10 80       	push   $0x8010842e
80104a85:	e8 06 b9 ff ff       	call   80100390 <panic>
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	53                   	push   %ebx
80104a96:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a99:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
{
80104a9e:	83 ec 3c             	sub    $0x3c,%esp
80104aa1:	eb 27                	jmp    80104aca <procdump+0x3a>
80104aa3:	90                   	nop
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	68 2f 89 10 80       	push   $0x8010892f
80104ab0:	e8 ab bb ff ff       	call   80100660 <cprintf>
80104ab5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ab8:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
80104abe:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
80104ac4:	0f 83 86 00 00 00    	jae    80104b50 <procdump+0xc0>
    if(p->state == UNUSED)
80104aca:	8b 43 10             	mov    0x10(%ebx),%eax
80104acd:	85 c0                	test   %eax,%eax
80104acf:	74 e7                	je     80104ab8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ad1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104ad4:	ba 59 85 10 80       	mov    $0x80108559,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ad9:	77 11                	ja     80104aec <procdump+0x5c>
80104adb:	8b 14 85 e8 85 10 80 	mov    -0x7fef7a18(,%eax,4),%edx
      state = "???";
80104ae2:	b8 59 85 10 80       	mov    $0x80108559,%eax
80104ae7:	85 d2                	test   %edx,%edx
80104ae9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104aec:	8d 43 70             	lea    0x70(%ebx),%eax
80104aef:	50                   	push   %eax
80104af0:	52                   	push   %edx
80104af1:	ff 73 14             	pushl  0x14(%ebx)
80104af4:	68 5d 85 10 80       	push   $0x8010855d
80104af9:	e8 62 bb ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104afe:	83 c4 10             	add    $0x10,%esp
80104b01:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104b05:	75 a1                	jne    80104aa8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b07:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b0a:	83 ec 08             	sub    $0x8,%esp
80104b0d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b10:	50                   	push   %eax
80104b11:	8b 43 20             	mov    0x20(%ebx),%eax
80104b14:	8b 40 0c             	mov    0xc(%eax),%eax
80104b17:	83 c0 08             	add    $0x8,%eax
80104b1a:	50                   	push   %eax
80104b1b:	e8 10 05 00 00       	call   80105030 <getcallerpcs>
80104b20:	83 c4 10             	add    $0x10,%esp
80104b23:	90                   	nop
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104b28:	8b 17                	mov    (%edi),%edx
80104b2a:	85 d2                	test   %edx,%edx
80104b2c:	0f 84 76 ff ff ff    	je     80104aa8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104b32:	83 ec 08             	sub    $0x8,%esp
80104b35:	83 c7 04             	add    $0x4,%edi
80104b38:	52                   	push   %edx
80104b39:	68 01 7f 10 80       	push   $0x80107f01
80104b3e:	e8 1d bb ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b43:	83 c4 10             	add    $0x10,%esp
80104b46:	39 fe                	cmp    %edi,%esi
80104b48:	75 de                	jne    80104b28 <procdump+0x98>
80104b4a:	e9 59 ff ff ff       	jmp    80104aa8 <procdump+0x18>
80104b4f:	90                   	nop
  }
}
80104b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b53:	5b                   	pop    %ebx
80104b54:	5e                   	pop    %esi
80104b55:	5f                   	pop    %edi
80104b56:	5d                   	pop    %ebp
80104b57:	c3                   	ret    
80104b58:	90                   	nop
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b60 <thread_create>:

int lwpNum = 1;

int thread_create(thread_t* thread, void* (*start_routine)(void*), void* arg) {
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	56                   	push   %esi
80104b65:	53                   	push   %ebx
80104b66:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80104b69:	e8 12 05 00 00       	call   80105080 <pushcli>
  c = mycpu();
80104b6e:	e8 0d f0 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80104b73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b79:	e8 42 05 00 00       	call   801050c0 <popcli>
	struct proc* np;
	struct proc* curproc = myproc();
	uint sz, sp, ustack[2];

	if ((np = allocproc()) == 0)
80104b7e:	e8 9d eb ff ff       	call   80103720 <allocproc>
80104b83:	85 c0                	test   %eax,%eax
80104b85:	0f 84 56 01 00 00    	je     80104ce1 <thread_create+0x181>
80104b8b:	89 c2                	mov    %eax,%edx
		return -1;

	// Duplicate manager's ofile, cwd, name
	for (int i = 0; i < NOFILE; i++)
80104b8d:	31 f6                	xor    %esi,%esi
80104b8f:	90                   	nop
		if (curproc->ofile[i])
80104b90:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80104b94:	85 c0                	test   %eax,%eax
80104b96:	74 16                	je     80104bae <thread_create+0x4e>
			np->ofile[i] = filedup(curproc->ofile[i]);
80104b98:	83 ec 0c             	sub    $0xc,%esp
80104b9b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b9e:	50                   	push   %eax
80104b9f:	e8 4c c2 ff ff       	call   80100df0 <filedup>
80104ba4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104ba7:	83 c4 10             	add    $0x10,%esp
80104baa:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
	for (int i = 0; i < NOFILE; i++)
80104bae:	83 c6 01             	add    $0x1,%esi
80104bb1:	83 fe 10             	cmp    $0x10,%esi
80104bb4:	75 da                	jne    80104b90 <thread_create+0x30>

	np->cwd = idup(curproc->cwd);
80104bb6:	83 ec 0c             	sub    $0xc,%esp
80104bb9:	ff 73 6c             	pushl  0x6c(%ebx)
80104bbc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104bbf:	e8 8c ca ff ff       	call   80101650 <idup>
80104bc4:	8b 55 d4             	mov    -0x2c(%ebp),%edx

	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104bc7:	83 c4 0c             	add    $0xc,%esp
	np->cwd = idup(curproc->cwd);
80104bca:	89 42 6c             	mov    %eax,0x6c(%edx)
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104bcd:	8d 43 70             	lea    0x70(%ebx),%eax
80104bd0:	6a 10                	push   $0x10
80104bd2:	50                   	push   %eax
80104bd3:	8d 42 70             	lea    0x70(%edx),%eax
80104bd6:	50                   	push   %eax
80104bd7:	e8 64 08 00 00       	call   80105440 <safestrcpy>

	np->sz = curproc->sz;
80104bdc:	8b 03                	mov    (%ebx),%eax
80104bde:	8b 55 d4             	mov    -0x2c(%ebp),%edx
	np->pid = curproc->pid;
	np->parent = curproc->parent;
	// If normal thread(not manager) calls thread_create()
	// Acts same as manager thread calls thread_create()
	// np's manager thread will be caller's manager thread
	if (curproc->isThread)
80104be1:	83 c4 10             	add    $0x10,%esp
	np->sz = curproc->sz;
80104be4:	89 02                	mov    %eax,(%edx)
	np->pgdir = curproc->pgdir;
80104be6:	8b 43 08             	mov    0x8(%ebx),%eax
80104be9:	89 42 08             	mov    %eax,0x8(%edx)
	np->pid = curproc->pid;
80104bec:	8b 43 14             	mov    0x14(%ebx),%eax
80104bef:	89 42 14             	mov    %eax,0x14(%edx)
	np->parent = curproc->parent;
80104bf2:	8b 43 18             	mov    0x18(%ebx),%eax
80104bf5:	89 42 18             	mov    %eax,0x18(%edx)
	if (curproc->isThread)
80104bf8:	8b bb 9c 00 00 00    	mov    0x9c(%ebx),%edi
80104bfe:	85 ff                	test   %edi,%edi
80104c00:	0f 85 ca 00 00 00    	jne    80104cd0 <thread_create+0x170>
		np->manager = curproc->manager;
	else
		np->manager = curproc;
80104c06:	89 9a 98 00 00 00    	mov    %ebx,0x98(%edx)
	lwpNum++;
80104c0c:	83 05 04 b0 10 80 01 	addl   $0x1,0x8010b004
	*np->tf = *curproc->tf;
80104c13:	8b 73 1c             	mov    0x1c(%ebx),%esi
80104c16:	b9 13 00 00 00       	mov    $0x13,%ecx
80104c1b:	8b 7a 1c             	mov    0x1c(%edx),%edi
	np->isThread = 1;

	// Allocate available tid by searching tid_alloc[]
	for (int i = 0; i < NPROC; i++) {
80104c1e:	31 c0                	xor    %eax,%eax
	*np->tf = *curproc->tf;
80104c20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	np->isThread = 1;
80104c22:	c7 82 9c 00 00 00 01 	movl   $0x1,0x9c(%edx)
80104c29:	00 00 00 
80104c2c:	eb 09                	jmp    80104c37 <thread_create+0xd7>
80104c2e:	66 90                	xchg   %ax,%ax
	for (int i = 0; i < NPROC; i++) {
80104c30:	83 f9 40             	cmp    $0x40,%ecx
80104c33:	89 c8                	mov    %ecx,%eax
80104c35:	74 1f                	je     80104c56 <thread_create+0xf6>
		if (tid_alloc[i] == 0) {
80104c37:	8b 34 85 e0 0f 11 80 	mov    -0x7feef020(,%eax,4),%esi
80104c3e:	8d 48 01             	lea    0x1(%eax),%ecx
80104c41:	85 f6                	test   %esi,%esi
80104c43:	75 eb                	jne    80104c30 <thread_create+0xd0>
			np->tid = i + 1;
80104c45:	89 8a a0 00 00 00    	mov    %ecx,0xa0(%edx)
			tid_alloc[i] = 1;
80104c4b:	c7 04 85 e0 0f 11 80 	movl   $0x1,-0x7feef020(,%eax,4)
80104c52:	01 00 00 00 
			break;
		}
	}

	*thread = np->tid;
80104c56:	8b 8a a0 00 00 00    	mov    0xa0(%edx),%ecx
80104c5c:	8b 45 08             	mov    0x8(%ebp),%eax

	ustack[0] = 0xFFFFFFFF;
	ustack[1] = (uint)arg;

	sp -= 8;
	if (copyout(np->pgdir, sp, ustack, 8) < 0)
80104c5f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	*thread = np->tid;
80104c62:	89 08                	mov    %ecx,(%eax)
	sz = curproc->usz + (uint)(2 * PGSIZE * (np->tid));
80104c64:	8b 82 a0 00 00 00    	mov    0xa0(%edx),%eax
	ustack[1] = (uint)arg;
80104c6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	sz = curproc->usz + (uint)(2 * PGSIZE * (np->tid));
80104c6d:	c1 e0 0d             	shl    $0xd,%eax
80104c70:	03 43 04             	add    0x4(%ebx),%eax
	np->usz = sz;
80104c73:	89 42 04             	mov    %eax,0x4(%edx)
	sp -= 8;
80104c76:	8d 58 f8             	lea    -0x8(%eax),%ebx
	if (copyout(np->pgdir, sp, ustack, 8) < 0)
80104c79:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104c7c:	6a 08                	push   $0x8
	ustack[1] = (uint)arg;
80104c7e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (copyout(np->pgdir, sp, ustack, 8) < 0)
80104c81:	50                   	push   %eax
80104c82:	53                   	push   %ebx
80104c83:	ff 72 08             	pushl  0x8(%edx)
	ustack[0] = 0xFFFFFFFF;
80104c86:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
	if (copyout(np->pgdir, sp, ustack, 8) < 0)
80104c8d:	e8 8e 31 00 00       	call   80107e20 <copyout>
80104c92:	83 c4 10             	add    $0x10,%esp
80104c95:	85 c0                	test   %eax,%eax
80104c97:	78 48                	js     80104ce1 <thread_create+0x181>
		return -1;

	// Set eip as an address of start_routine()
	np->tf->eip = (uint)start_routine;
80104c99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	np->tf->esp = sp;

	np->state = RUNNABLE;
	release(&ptable.lock);
80104c9f:	83 ec 0c             	sub    $0xc,%esp
	np->tf->eip = (uint)start_routine;
80104ca2:	8b 42 1c             	mov    0x1c(%edx),%eax
80104ca5:	89 48 38             	mov    %ecx,0x38(%eax)
	np->tf->esp = sp;
80104ca8:	8b 42 1c             	mov    0x1c(%edx),%eax
80104cab:	89 58 44             	mov    %ebx,0x44(%eax)
	np->state = RUNNABLE;
80104cae:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
	release(&ptable.lock);
80104cb5:	68 80 41 11 80       	push   $0x80114180
80104cba:	e8 51 05 00 00       	call   80105210 <release>

	return 0;
80104cbf:	83 c4 10             	add    $0x10,%esp
80104cc2:	31 c0                	xor    %eax,%eax
}
80104cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cc7:	5b                   	pop    %ebx
80104cc8:	5e                   	pop    %esi
80104cc9:	5f                   	pop    %edi
80104cca:	5d                   	pop    %ebp
80104ccb:	c3                   	ret    
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		np->manager = curproc->manager;
80104cd0:	8b 83 98 00 00 00    	mov    0x98(%ebx),%eax
80104cd6:	89 82 98 00 00 00    	mov    %eax,0x98(%edx)
80104cdc:	e9 2b ff ff ff       	jmp    80104c0c <thread_create+0xac>
		return -1;
80104ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce6:	eb dc                	jmp    80104cc4 <thread_create+0x164>
80104ce8:	90                   	nop
80104ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cf0 <thread_exit>:

void thread_exit(void* retval){
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
80104cf6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104cf9:	e8 82 03 00 00       	call   80105080 <pushcli>
  c = mycpu();
80104cfe:	e8 7d ee ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80104d03:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104d09:	e8 b2 03 00 00       	call   801050c0 <popcli>
80104d0e:	8d 5f 2c             	lea    0x2c(%edi),%ebx
80104d11:	8d 77 6c             	lea    0x6c(%edi),%esi
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	struct proc* curproc = myproc();
	int fd;

	// Close all open files.
	for (fd = 0; fd < NOFILE; fd++) {
		if (curproc->ofile[fd]) {
80104d18:	8b 03                	mov    (%ebx),%eax
80104d1a:	85 c0                	test   %eax,%eax
80104d1c:	74 12                	je     80104d30 <thread_exit+0x40>
			fileclose(curproc->ofile[fd]);
80104d1e:	83 ec 0c             	sub    $0xc,%esp
80104d21:	50                   	push   %eax
80104d22:	e8 19 c1 ff ff       	call   80100e40 <fileclose>
			curproc->ofile[fd] = 0;
80104d27:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104d2d:	83 c4 10             	add    $0x10,%esp
80104d30:	83 c3 04             	add    $0x4,%ebx
	for (fd = 0; fd < NOFILE; fd++) {
80104d33:	39 f3                	cmp    %esi,%ebx
80104d35:	75 e1                	jne    80104d18 <thread_exit+0x28>
		}
	}

	begin_op();
80104d37:	e8 64 de ff ff       	call   80102ba0 <begin_op>
	iput(curproc->cwd);
80104d3c:	83 ec 0c             	sub    $0xc,%esp
80104d3f:	ff 77 6c             	pushl  0x6c(%edi)
80104d42:	e8 69 ca ff ff       	call   801017b0 <iput>
	end_op();
80104d47:	e8 c4 de ff ff       	call   80102c10 <end_op>
	curproc->cwd = 0;
80104d4c:	c7 47 6c 00 00 00 00 	movl   $0x0,0x6c(%edi)

	acquire(&ptable.lock);
80104d53:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
80104d5a:	e8 f1 03 00 00       	call   80105150 <acquire>

	// Save retval value to LWP ret_val
	curproc->ret_val = retval;
80104d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d62:	89 87 a4 00 00 00    	mov    %eax,0xa4(%edi)

	// Manager process might be sleeping in wait().
	wakeup1(curproc->manager);
80104d68:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
80104d6e:	e8 fd e8 ff ff       	call   80103670 <wakeup1>

	// Jump into the scheduler, never to return.
	curproc->state = ZOMBIE;
80104d73:	c7 47 10 05 00 00 00 	movl   $0x5,0x10(%edi)
	sched();
80104d7a:	e8 c1 f5 ff ff       	call   80104340 <sched>
	panic("zombie exit");
80104d7f:	c7 04 24 36 85 10 80 	movl   $0x80108536,(%esp)
80104d86:	e8 05 b6 ff ff       	call   80100390 <panic>
80104d8b:	90                   	nop
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d90 <thread_join>:
}

int thread_join(thread_t thread, void** retval){
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	57                   	push   %edi
80104d94:	56                   	push   %esi
80104d95:	53                   	push   %ebx
80104d96:	83 ec 1c             	sub    $0x1c,%esp
80104d99:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80104d9c:	e8 df 02 00 00       	call   80105080 <pushcli>
  c = mycpu();
80104da1:	e8 da ed ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80104da6:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104dac:	e8 0f 03 00 00       	call   801050c0 <popcli>
	struct proc* p;
	struct proc* curproc = myproc();

	if (curproc->isThread)
80104db1:	8b 86 9c 00 00 00    	mov    0x9c(%esi),%eax
80104db7:	85 c0                	test   %eax,%eax
80104db9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104dbc:	0f 85 04 01 00 00    	jne    80104ec6 <thread_join+0x136>
		panic("If it is not manager, cannot call thread_join()");

	acquire(&ptable.lock);
80104dc2:	83 ec 0c             	sub    $0xc,%esp
80104dc5:	68 80 41 11 80       	push   $0x80114180
80104dca:	e8 81 03 00 00       	call   80105150 <acquire>
80104dcf:	83 c4 10             	add    $0x10,%esp
	for (;;) {
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104dd2:	bb b4 41 11 80       	mov    $0x801141b4,%ebx
80104dd7:	eb 19                	jmp    80104df2 <thread_join+0x62>
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104de0:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
80104de6:	81 fb b4 6b 11 80    	cmp    $0x80116bb4,%ebx
80104dec:	0f 83 9e 00 00 00    	jae    80104e90 <thread_join+0x100>
			if (!p->isThread || p->tid != thread)
80104df2:	8b 93 9c 00 00 00    	mov    0x9c(%ebx),%edx
80104df8:	85 d2                	test   %edx,%edx
80104dfa:	74 e4                	je     80104de0 <thread_join+0x50>
80104dfc:	39 bb a0 00 00 00    	cmp    %edi,0xa0(%ebx)
80104e02:	75 dc                	jne    80104de0 <thread_join+0x50>
				continue;

			if (p->state == ZOMBIE) {
80104e04:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
80104e08:	75 d6                	jne    80104de0 <thread_join+0x50>
				*retval = (void*)p->ret_val;
80104e0a:	8b 93 a4 00 00 00    	mov    0xa4(%ebx),%edx
80104e10:	8b 45 0c             	mov    0xc(%ebp),%eax

				kfree(p->kstack);
80104e13:	83 ec 0c             	sub    $0xc,%esp
				*retval = (void*)p->ret_val;
80104e16:	89 10                	mov    %edx,(%eax)
				kfree(p->kstack);
80104e18:	ff 73 0c             	pushl  0xc(%ebx)
80104e1b:	e8 f0 d4 ff ff       	call   80102310 <kfree>
				p->parent = 0;
				p->name[0] = 0;
				p->killed = 0;
				p->isThread = 0;
				// Return its tid
				tid_alloc[p->tid - 1] = 0;
80104e20:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
				p->tid = 0;
				p->state = UNUSED;

				release(&ptable.lock);
80104e26:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
				p->kstack = 0;
80104e2d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
				p->pid = 0;
80104e34:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
				p->parent = 0;
80104e3b:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
				p->name[0] = 0;
80104e42:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
				p->killed = 0;
80104e46:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
				p->isThread = 0;
80104e4d:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80104e54:	00 00 00 
				tid_alloc[p->tid - 1] = 0;
80104e57:	c7 04 85 dc 0f 11 80 	movl   $0x0,-0x7feef024(,%eax,4)
80104e5e:	00 00 00 00 
				p->tid = 0;
80104e62:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
80104e69:	00 00 00 
				p->state = UNUSED;
80104e6c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
				release(&ptable.lock);
80104e73:	e8 98 03 00 00       	call   80105210 <release>
				return 0;
80104e78:	83 c4 10             	add    $0x10,%esp
		}

		// Wait for normal thread to exit
		sleep(curproc, &ptable.lock);
	}
}
80104e7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e81:	5b                   	pop    %ebx
80104e82:	5e                   	pop    %esi
80104e83:	5f                   	pop    %edi
80104e84:	5d                   	pop    %ebp
80104e85:	c3                   	ret    
80104e86:	8d 76 00             	lea    0x0(%esi),%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		if (curproc->killed) {
80104e90:	8b 46 28             	mov    0x28(%esi),%eax
80104e93:	85 c0                	test   %eax,%eax
80104e95:	75 16                	jne    80104ead <thread_join+0x11d>
		sleep(curproc, &ptable.lock);
80104e97:	83 ec 08             	sub    $0x8,%esp
80104e9a:	68 80 41 11 80       	push   $0x80114180
80104e9f:	56                   	push   %esi
80104ea0:	e8 db f8 ff ff       	call   80104780 <sleep>
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104ea5:	83 c4 10             	add    $0x10,%esp
80104ea8:	e9 25 ff ff ff       	jmp    80104dd2 <thread_join+0x42>
			release(&ptable.lock);
80104ead:	83 ec 0c             	sub    $0xc,%esp
80104eb0:	68 80 41 11 80       	push   $0x80114180
80104eb5:	e8 56 03 00 00       	call   80105210 <release>
			return -1;
80104eba:	83 c4 10             	add    $0x10,%esp
80104ebd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104ec4:	eb b5                	jmp    80104e7b <thread_join+0xeb>
		panic("If it is not manager, cannot call thread_join()");
80104ec6:	83 ec 0c             	sub    $0xc,%esp
80104ec9:	68 b8 85 10 80       	push   $0x801085b8
80104ece:	e8 bd b4 ff ff       	call   80100390 <panic>
80104ed3:	66 90                	xchg   %ax,%ax
80104ed5:	66 90                	xchg   %ax,%ax
80104ed7:	66 90                	xchg   %ax,%ax
80104ed9:	66 90                	xchg   %ax,%ax
80104edb:	66 90                	xchg   %ax,%ax
80104edd:	66 90                	xchg   %ax,%ax
80104edf:	90                   	nop

80104ee0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	53                   	push   %ebx
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104eea:	68 18 86 10 80       	push   $0x80108618
80104eef:	8d 43 04             	lea    0x4(%ebx),%eax
80104ef2:	50                   	push   %eax
80104ef3:	e8 18 01 00 00       	call   80105010 <initlock>
  lk->name = name;
80104ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104efb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104f01:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104f04:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104f0b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f11:	c9                   	leave  
80104f12:	c3                   	ret    
80104f13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
80104f25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f28:	83 ec 0c             	sub    $0xc,%esp
80104f2b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f2e:	56                   	push   %esi
80104f2f:	e8 1c 02 00 00       	call   80105150 <acquire>
  while (lk->locked) {
80104f34:	8b 13                	mov    (%ebx),%edx
80104f36:	83 c4 10             	add    $0x10,%esp
80104f39:	85 d2                	test   %edx,%edx
80104f3b:	74 16                	je     80104f53 <acquiresleep+0x33>
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104f40:	83 ec 08             	sub    $0x8,%esp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
80104f45:	e8 36 f8 ff ff       	call   80104780 <sleep>
  while (lk->locked) {
80104f4a:	8b 03                	mov    (%ebx),%eax
80104f4c:	83 c4 10             	add    $0x10,%esp
80104f4f:	85 c0                	test   %eax,%eax
80104f51:	75 ed                	jne    80104f40 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104f53:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104f59:	e8 12 ee ff ff       	call   80103d70 <myproc>
80104f5e:	8b 40 14             	mov    0x14(%eax),%eax
80104f61:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104f64:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f67:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f6a:	5b                   	pop    %ebx
80104f6b:	5e                   	pop    %esi
80104f6c:	5d                   	pop    %ebp
  release(&lk->lk);
80104f6d:	e9 9e 02 00 00       	jmp    80105210 <release>
80104f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
80104f85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f88:	83 ec 0c             	sub    $0xc,%esp
80104f8b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f8e:	56                   	push   %esi
80104f8f:	e8 bc 01 00 00       	call   80105150 <acquire>
  lk->locked = 0;
80104f94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104f9a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104fa1:	89 1c 24             	mov    %ebx,(%esp)
80104fa4:	e8 d7 f9 ff ff       	call   80104980 <wakeup>
  release(&lk->lk);
80104fa9:	89 75 08             	mov    %esi,0x8(%ebp)
80104fac:	83 c4 10             	add    $0x10,%esp
}
80104faf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fb2:	5b                   	pop    %ebx
80104fb3:	5e                   	pop    %esi
80104fb4:	5d                   	pop    %ebp
  release(&lk->lk);
80104fb5:	e9 56 02 00 00       	jmp    80105210 <release>
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	57                   	push   %edi
80104fc4:	56                   	push   %esi
80104fc5:	53                   	push   %ebx
80104fc6:	31 ff                	xor    %edi,%edi
80104fc8:	83 ec 18             	sub    $0x18,%esp
80104fcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104fce:	8d 73 04             	lea    0x4(%ebx),%esi
80104fd1:	56                   	push   %esi
80104fd2:	e8 79 01 00 00       	call   80105150 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104fd7:	8b 03                	mov    (%ebx),%eax
80104fd9:	83 c4 10             	add    $0x10,%esp
80104fdc:	85 c0                	test   %eax,%eax
80104fde:	74 13                	je     80104ff3 <holdingsleep+0x33>
80104fe0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104fe3:	e8 88 ed ff ff       	call   80103d70 <myproc>
80104fe8:	39 58 14             	cmp    %ebx,0x14(%eax)
80104feb:	0f 94 c0             	sete   %al
80104fee:	0f b6 c0             	movzbl %al,%eax
80104ff1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104ff3:	83 ec 0c             	sub    $0xc,%esp
80104ff6:	56                   	push   %esi
80104ff7:	e8 14 02 00 00       	call   80105210 <release>
  return r;
}
80104ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fff:	89 f8                	mov    %edi,%eax
80105001:	5b                   	pop    %ebx
80105002:	5e                   	pop    %esi
80105003:	5f                   	pop    %edi
80105004:	5d                   	pop    %ebp
80105005:	c3                   	ret    
80105006:	66 90                	xchg   %ax,%ax
80105008:	66 90                	xchg   %ax,%ax
8010500a:	66 90                	xchg   %ax,%ax
8010500c:	66 90                	xchg   %ax,%ax
8010500e:	66 90                	xchg   %ax,%ax

80105010 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105016:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105019:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010501f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105022:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105029:	5d                   	pop    %ebp
8010502a:	c3                   	ret    
8010502b:	90                   	nop
8010502c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105030 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105030:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105031:	31 d2                	xor    %edx,%edx
{
80105033:	89 e5                	mov    %esp,%ebp
80105035:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105036:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105039:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010503c:	83 e8 08             	sub    $0x8,%eax
8010503f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105040:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105046:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010504c:	77 1a                	ja     80105068 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010504e:	8b 58 04             	mov    0x4(%eax),%ebx
80105051:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105054:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105057:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105059:	83 fa 0a             	cmp    $0xa,%edx
8010505c:	75 e2                	jne    80105040 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010505e:	5b                   	pop    %ebx
8010505f:	5d                   	pop    %ebp
80105060:	c3                   	ret    
80105061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105068:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010506b:	83 c1 28             	add    $0x28,%ecx
8010506e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105076:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105079:	39 c1                	cmp    %eax,%ecx
8010507b:	75 f3                	jne    80105070 <getcallerpcs+0x40>
}
8010507d:	5b                   	pop    %ebx
8010507e:	5d                   	pop    %ebp
8010507f:	c3                   	ret    

80105080 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	53                   	push   %ebx
80105084:	83 ec 04             	sub    $0x4,%esp
80105087:	9c                   	pushf  
80105088:	5b                   	pop    %ebx
  asm volatile("cli");
80105089:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010508a:	e8 f1 ea ff ff       	call   80103b80 <mycpu>
8010508f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105095:	85 c0                	test   %eax,%eax
80105097:	75 11                	jne    801050aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105099:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010509f:	e8 dc ea ff ff       	call   80103b80 <mycpu>
801050a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801050aa:	e8 d1 ea ff ff       	call   80103b80 <mycpu>
801050af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801050b6:	83 c4 04             	add    $0x4,%esp
801050b9:	5b                   	pop    %ebx
801050ba:	5d                   	pop    %ebp
801050bb:	c3                   	ret    
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050c0 <popcli>:

void
popcli(void)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801050c6:	9c                   	pushf  
801050c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801050c8:	f6 c4 02             	test   $0x2,%ah
801050cb:	75 35                	jne    80105102 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801050cd:	e8 ae ea ff ff       	call   80103b80 <mycpu>
801050d2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801050d9:	78 34                	js     8010510f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050db:	e8 a0 ea ff ff       	call   80103b80 <mycpu>
801050e0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050e6:	85 d2                	test   %edx,%edx
801050e8:	74 06                	je     801050f0 <popcli+0x30>
    sti();
}
801050ea:	c9                   	leave  
801050eb:	c3                   	ret    
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050f0:	e8 8b ea ff ff       	call   80103b80 <mycpu>
801050f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801050fb:	85 c0                	test   %eax,%eax
801050fd:	74 eb                	je     801050ea <popcli+0x2a>
  asm volatile("sti");
801050ff:	fb                   	sti    
}
80105100:	c9                   	leave  
80105101:	c3                   	ret    
    panic("popcli - interruptible");
80105102:	83 ec 0c             	sub    $0xc,%esp
80105105:	68 23 86 10 80       	push   $0x80108623
8010510a:	e8 81 b2 ff ff       	call   80100390 <panic>
    panic("popcli");
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	68 3a 86 10 80       	push   $0x8010863a
80105117:	e8 74 b2 ff ff       	call   80100390 <panic>
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <holding>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 75 08             	mov    0x8(%ebp),%esi
80105128:	31 db                	xor    %ebx,%ebx
  pushcli();
8010512a:	e8 51 ff ff ff       	call   80105080 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010512f:	8b 06                	mov    (%esi),%eax
80105131:	85 c0                	test   %eax,%eax
80105133:	74 10                	je     80105145 <holding+0x25>
80105135:	8b 5e 08             	mov    0x8(%esi),%ebx
80105138:	e8 43 ea ff ff       	call   80103b80 <mycpu>
8010513d:	39 c3                	cmp    %eax,%ebx
8010513f:	0f 94 c3             	sete   %bl
80105142:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105145:	e8 76 ff ff ff       	call   801050c0 <popcli>
}
8010514a:	89 d8                	mov    %ebx,%eax
8010514c:	5b                   	pop    %ebx
8010514d:	5e                   	pop    %esi
8010514e:	5d                   	pop    %ebp
8010514f:	c3                   	ret    

80105150 <acquire>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105155:	e8 26 ff ff ff       	call   80105080 <pushcli>
  if(holding(lk))
8010515a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010515d:	83 ec 0c             	sub    $0xc,%esp
80105160:	53                   	push   %ebx
80105161:	e8 ba ff ff ff       	call   80105120 <holding>
80105166:	83 c4 10             	add    $0x10,%esp
80105169:	85 c0                	test   %eax,%eax
8010516b:	0f 85 83 00 00 00    	jne    801051f4 <acquire+0xa4>
80105171:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105173:	ba 01 00 00 00       	mov    $0x1,%edx
80105178:	eb 09                	jmp    80105183 <acquire+0x33>
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105180:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105183:	89 d0                	mov    %edx,%eax
80105185:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105188:	85 c0                	test   %eax,%eax
8010518a:	75 f4                	jne    80105180 <acquire+0x30>
  __sync_synchronize();
8010518c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105191:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105194:	e8 e7 e9 ff ff       	call   80103b80 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105199:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010519c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010519f:	89 e8                	mov    %ebp,%eax
801051a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051a8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801051ae:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801051b4:	77 1a                	ja     801051d0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801051b6:	8b 48 04             	mov    0x4(%eax),%ecx
801051b9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801051bc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801051bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801051c1:	83 fe 0a             	cmp    $0xa,%esi
801051c4:	75 e2                	jne    801051a8 <acquire+0x58>
}
801051c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051c9:	5b                   	pop    %ebx
801051ca:	5e                   	pop    %esi
801051cb:	5d                   	pop    %ebp
801051cc:	c3                   	ret    
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801051d3:	83 c2 28             	add    $0x28,%edx
801051d6:	8d 76 00             	lea    0x0(%esi),%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801051e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801051e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801051e9:	39 d0                	cmp    %edx,%eax
801051eb:	75 f3                	jne    801051e0 <acquire+0x90>
}
801051ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051f0:	5b                   	pop    %ebx
801051f1:	5e                   	pop    %esi
801051f2:	5d                   	pop    %ebp
801051f3:	c3                   	ret    
    panic("acquire");
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	68 41 86 10 80       	push   $0x80108641
801051fc:	e8 8f b1 ff ff       	call   80100390 <panic>
80105201:	eb 0d                	jmp    80105210 <release>
80105203:	90                   	nop
80105204:	90                   	nop
80105205:	90                   	nop
80105206:	90                   	nop
80105207:	90                   	nop
80105208:	90                   	nop
80105209:	90                   	nop
8010520a:	90                   	nop
8010520b:	90                   	nop
8010520c:	90                   	nop
8010520d:	90                   	nop
8010520e:	90                   	nop
8010520f:	90                   	nop

80105210 <release>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	53                   	push   %ebx
80105214:	83 ec 10             	sub    $0x10,%esp
80105217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010521a:	53                   	push   %ebx
8010521b:	e8 00 ff ff ff       	call   80105120 <holding>
80105220:	83 c4 10             	add    $0x10,%esp
80105223:	85 c0                	test   %eax,%eax
80105225:	74 22                	je     80105249 <release+0x39>
  lk->pcs[0] = 0;
80105227:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010522e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105235:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010523a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105243:	c9                   	leave  
  popcli();
80105244:	e9 77 fe ff ff       	jmp    801050c0 <popcli>
    panic("release");
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	68 49 86 10 80       	push   $0x80108649
80105251:	e8 3a b1 ff ff       	call   80100390 <panic>
80105256:	66 90                	xchg   %ax,%ax
80105258:	66 90                	xchg   %ax,%ax
8010525a:	66 90                	xchg   %ax,%ax
8010525c:	66 90                	xchg   %ax,%ax
8010525e:	66 90                	xchg   %ax,%ax

80105260 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	53                   	push   %ebx
80105265:	8b 55 08             	mov    0x8(%ebp),%edx
80105268:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010526b:	f6 c2 03             	test   $0x3,%dl
8010526e:	75 05                	jne    80105275 <memset+0x15>
80105270:	f6 c1 03             	test   $0x3,%cl
80105273:	74 13                	je     80105288 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105275:	89 d7                	mov    %edx,%edi
80105277:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527a:	fc                   	cld    
8010527b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010527d:	5b                   	pop    %ebx
8010527e:	89 d0                	mov    %edx,%eax
80105280:	5f                   	pop    %edi
80105281:	5d                   	pop    %ebp
80105282:	c3                   	ret    
80105283:	90                   	nop
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105288:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010528c:	c1 e9 02             	shr    $0x2,%ecx
8010528f:	89 f8                	mov    %edi,%eax
80105291:	89 fb                	mov    %edi,%ebx
80105293:	c1 e0 18             	shl    $0x18,%eax
80105296:	c1 e3 10             	shl    $0x10,%ebx
80105299:	09 d8                	or     %ebx,%eax
8010529b:	09 f8                	or     %edi,%eax
8010529d:	c1 e7 08             	shl    $0x8,%edi
801052a0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801052a2:	89 d7                	mov    %edx,%edi
801052a4:	fc                   	cld    
801052a5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801052a7:	5b                   	pop    %ebx
801052a8:	89 d0                	mov    %edx,%eax
801052aa:	5f                   	pop    %edi
801052ab:	5d                   	pop    %ebp
801052ac:	c3                   	ret    
801052ad:	8d 76 00             	lea    0x0(%esi),%esi

801052b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	53                   	push   %ebx
801052b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801052b9:	8b 75 08             	mov    0x8(%ebp),%esi
801052bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052bf:	85 db                	test   %ebx,%ebx
801052c1:	74 29                	je     801052ec <memcmp+0x3c>
    if(*s1 != *s2)
801052c3:	0f b6 16             	movzbl (%esi),%edx
801052c6:	0f b6 0f             	movzbl (%edi),%ecx
801052c9:	38 d1                	cmp    %dl,%cl
801052cb:	75 2b                	jne    801052f8 <memcmp+0x48>
801052cd:	b8 01 00 00 00       	mov    $0x1,%eax
801052d2:	eb 14                	jmp    801052e8 <memcmp+0x38>
801052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801052dc:	83 c0 01             	add    $0x1,%eax
801052df:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801052e4:	38 ca                	cmp    %cl,%dl
801052e6:	75 10                	jne    801052f8 <memcmp+0x48>
  while(n-- > 0){
801052e8:	39 d8                	cmp    %ebx,%eax
801052ea:	75 ec                	jne    801052d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801052ec:	5b                   	pop    %ebx
  return 0;
801052ed:	31 c0                	xor    %eax,%eax
}
801052ef:	5e                   	pop    %esi
801052f0:	5f                   	pop    %edi
801052f1:	5d                   	pop    %ebp
801052f2:	c3                   	ret    
801052f3:	90                   	nop
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801052f8:	0f b6 c2             	movzbl %dl,%eax
}
801052fb:	5b                   	pop    %ebx
      return *s1 - *s2;
801052fc:	29 c8                	sub    %ecx,%eax
}
801052fe:	5e                   	pop    %esi
801052ff:	5f                   	pop    %edi
80105300:	5d                   	pop    %ebp
80105301:	c3                   	ret    
80105302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105310 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	56                   	push   %esi
80105314:	53                   	push   %ebx
80105315:	8b 45 08             	mov    0x8(%ebp),%eax
80105318:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010531b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010531e:	39 c3                	cmp    %eax,%ebx
80105320:	73 26                	jae    80105348 <memmove+0x38>
80105322:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105325:	39 c8                	cmp    %ecx,%eax
80105327:	73 1f                	jae    80105348 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105329:	85 f6                	test   %esi,%esi
8010532b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010532e:	74 0f                	je     8010533f <memmove+0x2f>
      *--d = *--s;
80105330:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105334:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105337:	83 ea 01             	sub    $0x1,%edx
8010533a:	83 fa ff             	cmp    $0xffffffff,%edx
8010533d:	75 f1                	jne    80105330 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010533f:	5b                   	pop    %ebx
80105340:	5e                   	pop    %esi
80105341:	5d                   	pop    %ebp
80105342:	c3                   	ret    
80105343:	90                   	nop
80105344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105348:	31 d2                	xor    %edx,%edx
8010534a:	85 f6                	test   %esi,%esi
8010534c:	74 f1                	je     8010533f <memmove+0x2f>
8010534e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105350:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105354:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105357:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010535a:	39 d6                	cmp    %edx,%esi
8010535c:	75 f2                	jne    80105350 <memmove+0x40>
}
8010535e:	5b                   	pop    %ebx
8010535f:	5e                   	pop    %esi
80105360:	5d                   	pop    %ebp
80105361:	c3                   	ret    
80105362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105373:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105374:	eb 9a                	jmp    80105310 <memmove>
80105376:	8d 76 00             	lea    0x0(%esi),%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
80105385:	8b 7d 10             	mov    0x10(%ebp),%edi
80105388:	53                   	push   %ebx
80105389:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010538c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010538f:	85 ff                	test   %edi,%edi
80105391:	74 2f                	je     801053c2 <strncmp+0x42>
80105393:	0f b6 01             	movzbl (%ecx),%eax
80105396:	0f b6 1e             	movzbl (%esi),%ebx
80105399:	84 c0                	test   %al,%al
8010539b:	74 37                	je     801053d4 <strncmp+0x54>
8010539d:	38 c3                	cmp    %al,%bl
8010539f:	75 33                	jne    801053d4 <strncmp+0x54>
801053a1:	01 f7                	add    %esi,%edi
801053a3:	eb 13                	jmp    801053b8 <strncmp+0x38>
801053a5:	8d 76 00             	lea    0x0(%esi),%esi
801053a8:	0f b6 01             	movzbl (%ecx),%eax
801053ab:	84 c0                	test   %al,%al
801053ad:	74 21                	je     801053d0 <strncmp+0x50>
801053af:	0f b6 1a             	movzbl (%edx),%ebx
801053b2:	89 d6                	mov    %edx,%esi
801053b4:	38 d8                	cmp    %bl,%al
801053b6:	75 1c                	jne    801053d4 <strncmp+0x54>
    n--, p++, q++;
801053b8:	8d 56 01             	lea    0x1(%esi),%edx
801053bb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801053be:	39 fa                	cmp    %edi,%edx
801053c0:	75 e6                	jne    801053a8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801053c2:	5b                   	pop    %ebx
    return 0;
801053c3:	31 c0                	xor    %eax,%eax
}
801053c5:	5e                   	pop    %esi
801053c6:	5f                   	pop    %edi
801053c7:	5d                   	pop    %ebp
801053c8:	c3                   	ret    
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053d0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801053d4:	29 d8                	sub    %ebx,%eax
}
801053d6:	5b                   	pop    %ebx
801053d7:	5e                   	pop    %esi
801053d8:	5f                   	pop    %edi
801053d9:	5d                   	pop    %ebp
801053da:	c3                   	ret    
801053db:	90                   	nop
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
801053e5:	8b 45 08             	mov    0x8(%ebp),%eax
801053e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801053eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801053ee:	89 c2                	mov    %eax,%edx
801053f0:	eb 19                	jmp    8010540b <strncpy+0x2b>
801053f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053f8:	83 c3 01             	add    $0x1,%ebx
801053fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801053ff:	83 c2 01             	add    $0x1,%edx
80105402:	84 c9                	test   %cl,%cl
80105404:	88 4a ff             	mov    %cl,-0x1(%edx)
80105407:	74 09                	je     80105412 <strncpy+0x32>
80105409:	89 f1                	mov    %esi,%ecx
8010540b:	85 c9                	test   %ecx,%ecx
8010540d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105410:	7f e6                	jg     801053f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105412:	31 c9                	xor    %ecx,%ecx
80105414:	85 f6                	test   %esi,%esi
80105416:	7e 17                	jle    8010542f <strncpy+0x4f>
80105418:	90                   	nop
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105420:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105424:	89 f3                	mov    %esi,%ebx
80105426:	83 c1 01             	add    $0x1,%ecx
80105429:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010542b:	85 db                	test   %ebx,%ebx
8010542d:	7f f1                	jg     80105420 <strncpy+0x40>
  return os;
}
8010542f:	5b                   	pop    %ebx
80105430:	5e                   	pop    %esi
80105431:	5d                   	pop    %ebp
80105432:	c3                   	ret    
80105433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
80105445:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105448:	8b 45 08             	mov    0x8(%ebp),%eax
8010544b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010544e:	85 c9                	test   %ecx,%ecx
80105450:	7e 26                	jle    80105478 <safestrcpy+0x38>
80105452:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105456:	89 c1                	mov    %eax,%ecx
80105458:	eb 17                	jmp    80105471 <safestrcpy+0x31>
8010545a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105460:	83 c2 01             	add    $0x1,%edx
80105463:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105467:	83 c1 01             	add    $0x1,%ecx
8010546a:	84 db                	test   %bl,%bl
8010546c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010546f:	74 04                	je     80105475 <safestrcpy+0x35>
80105471:	39 f2                	cmp    %esi,%edx
80105473:	75 eb                	jne    80105460 <safestrcpy+0x20>
    ;
  *s = 0;
80105475:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105478:	5b                   	pop    %ebx
80105479:	5e                   	pop    %esi
8010547a:	5d                   	pop    %ebp
8010547b:	c3                   	ret    
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <strlen>:

int
strlen(const char *s)
{
80105480:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105481:	31 c0                	xor    %eax,%eax
{
80105483:	89 e5                	mov    %esp,%ebp
80105485:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105488:	80 3a 00             	cmpb   $0x0,(%edx)
8010548b:	74 0c                	je     80105499 <strlen+0x19>
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
80105490:	83 c0 01             	add    $0x1,%eax
80105493:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105497:	75 f7                	jne    80105490 <strlen+0x10>
    ;
  return n;
}
80105499:	5d                   	pop    %ebp
8010549a:	c3                   	ret    

8010549b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010549b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010549f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801054a3:	55                   	push   %ebp
  pushl %ebx
801054a4:	53                   	push   %ebx
  pushl %esi
801054a5:	56                   	push   %esi
  pushl %edi
801054a6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801054a7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801054a9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801054ab:	5f                   	pop    %edi
  popl %esi
801054ac:	5e                   	pop    %esi
  popl %ebx
801054ad:	5b                   	pop    %ebx
  popl %ebp
801054ae:	5d                   	pop    %ebp
  ret
801054af:	c3                   	ret    

801054b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	53                   	push   %ebx
801054b4:	83 ec 04             	sub    $0x4,%esp
801054b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801054ba:	e8 b1 e8 ff ff       	call   80103d70 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054bf:	8b 00                	mov    (%eax),%eax
801054c1:	39 d8                	cmp    %ebx,%eax
801054c3:	76 1b                	jbe    801054e0 <fetchint+0x30>
801054c5:	8d 53 04             	lea    0x4(%ebx),%edx
801054c8:	39 d0                	cmp    %edx,%eax
801054ca:	72 14                	jb     801054e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801054cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cf:	8b 13                	mov    (%ebx),%edx
801054d1:	89 10                	mov    %edx,(%eax)
  return 0;
801054d3:	31 c0                	xor    %eax,%eax
}
801054d5:	83 c4 04             	add    $0x4,%esp
801054d8:	5b                   	pop    %ebx
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    
801054db:	90                   	nop
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801054e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e5:	eb ee                	jmp    801054d5 <fetchint+0x25>
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	53                   	push   %ebx
801054f4:	83 ec 04             	sub    $0x4,%esp
801054f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801054fa:	e8 71 e8 ff ff       	call   80103d70 <myproc>

  if(addr >= curproc->sz)
801054ff:	39 18                	cmp    %ebx,(%eax)
80105501:	76 29                	jbe    8010552c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105506:	89 da                	mov    %ebx,%edx
80105508:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010550a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010550c:	39 c3                	cmp    %eax,%ebx
8010550e:	73 1c                	jae    8010552c <fetchstr+0x3c>
    if(*s == 0)
80105510:	80 3b 00             	cmpb   $0x0,(%ebx)
80105513:	75 10                	jne    80105525 <fetchstr+0x35>
80105515:	eb 39                	jmp    80105550 <fetchstr+0x60>
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105520:	80 3a 00             	cmpb   $0x0,(%edx)
80105523:	74 1b                	je     80105540 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105525:	83 c2 01             	add    $0x1,%edx
80105528:	39 d0                	cmp    %edx,%eax
8010552a:	77 f4                	ja     80105520 <fetchstr+0x30>
    return -1;
8010552c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105531:	83 c4 04             	add    $0x4,%esp
80105534:	5b                   	pop    %ebx
80105535:	5d                   	pop    %ebp
80105536:	c3                   	ret    
80105537:	89 f6                	mov    %esi,%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105540:	83 c4 04             	add    $0x4,%esp
80105543:	89 d0                	mov    %edx,%eax
80105545:	29 d8                	sub    %ebx,%eax
80105547:	5b                   	pop    %ebx
80105548:	5d                   	pop    %ebp
80105549:	c3                   	ret    
8010554a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105550:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105552:	eb dd                	jmp    80105531 <fetchstr+0x41>
80105554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010555a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105560 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105565:	e8 06 e8 ff ff       	call   80103d70 <myproc>
8010556a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010556d:	8b 55 08             	mov    0x8(%ebp),%edx
80105570:	8b 40 44             	mov    0x44(%eax),%eax
80105573:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105576:	e8 f5 e7 ff ff       	call   80103d70 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010557b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010557d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105580:	39 c6                	cmp    %eax,%esi
80105582:	73 1c                	jae    801055a0 <argint+0x40>
80105584:	8d 53 08             	lea    0x8(%ebx),%edx
80105587:	39 d0                	cmp    %edx,%eax
80105589:	72 15                	jb     801055a0 <argint+0x40>
  *ip = *(int*)(addr);
8010558b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558e:	8b 53 04             	mov    0x4(%ebx),%edx
80105591:	89 10                	mov    %edx,(%eax)
  return 0;
80105593:	31 c0                	xor    %eax,%eax
}
80105595:	5b                   	pop    %ebx
80105596:	5e                   	pop    %esi
80105597:	5d                   	pop    %ebp
80105598:	c3                   	ret    
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055a5:	eb ee                	jmp    80105595 <argint+0x35>
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
801055b5:	83 ec 10             	sub    $0x10,%esp
801055b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801055bb:	e8 b0 e7 ff ff       	call   80103d70 <myproc>
801055c0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801055c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c5:	83 ec 08             	sub    $0x8,%esp
801055c8:	50                   	push   %eax
801055c9:	ff 75 08             	pushl  0x8(%ebp)
801055cc:	e8 8f ff ff ff       	call   80105560 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055d1:	83 c4 10             	add    $0x10,%esp
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 28                	js     80105600 <argptr+0x50>
801055d8:	85 db                	test   %ebx,%ebx
801055da:	78 24                	js     80105600 <argptr+0x50>
801055dc:	8b 16                	mov    (%esi),%edx
801055de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e1:	39 c2                	cmp    %eax,%edx
801055e3:	76 1b                	jbe    80105600 <argptr+0x50>
801055e5:	01 c3                	add    %eax,%ebx
801055e7:	39 da                	cmp    %ebx,%edx
801055e9:	72 15                	jb     80105600 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801055eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801055ee:	89 02                	mov    %eax,(%edx)
  return 0;
801055f0:	31 c0                	xor    %eax,%eax
}
801055f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055f5:	5b                   	pop    %ebx
801055f6:	5e                   	pop    %esi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105605:	eb eb                	jmp    801055f2 <argptr+0x42>
80105607:	89 f6                	mov    %esi,%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105616:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105619:	50                   	push   %eax
8010561a:	ff 75 08             	pushl  0x8(%ebp)
8010561d:	e8 3e ff ff ff       	call   80105560 <argint>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	78 17                	js     80105640 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105629:	83 ec 08             	sub    $0x8,%esp
8010562c:	ff 75 0c             	pushl  0xc(%ebp)
8010562f:	ff 75 f4             	pushl  -0xc(%ebp)
80105632:	e8 b9 fe ff ff       	call   801054f0 <fetchstr>
80105637:	83 c4 10             	add    $0x10,%esp
}
8010563a:	c9                   	leave  
8010563b:	c3                   	ret    
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <syscall>:
[SYS_thread_join] sys_thread_join,
};

void
syscall(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	53                   	push   %ebx
80105654:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105657:	e8 14 e7 ff ff       	call   80103d70 <myproc>
8010565c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010565e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105661:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105664:	8d 50 ff             	lea    -0x1(%eax),%edx
80105667:	83 fa 1a             	cmp    $0x1a,%edx
8010566a:	77 1c                	ja     80105688 <syscall+0x38>
8010566c:	8b 14 85 80 86 10 80 	mov    -0x7fef7980(,%eax,4),%edx
80105673:	85 d2                	test   %edx,%edx
80105675:	74 11                	je     80105688 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105677:	ff d2                	call   *%edx
80105679:	8b 53 1c             	mov    0x1c(%ebx),%edx
8010567c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010567f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105682:	c9                   	leave  
80105683:	c3                   	ret    
80105684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105688:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105689:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010568c:	50                   	push   %eax
8010568d:	ff 73 14             	pushl  0x14(%ebx)
80105690:	68 51 86 10 80       	push   $0x80108651
80105695:	e8 c6 af ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010569a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801056a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056aa:	c9                   	leave  
801056ab:	c3                   	ret    
801056ac:	66 90                	xchg   %ax,%ax
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
801056b5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056b6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801056b9:	83 ec 34             	sub    $0x34,%esp
801056bc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801056bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801056c2:	56                   	push   %esi
801056c3:	50                   	push   %eax
{
801056c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801056c7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801056ca:	e8 31 c8 ff ff       	call   80101f00 <nameiparent>
801056cf:	83 c4 10             	add    $0x10,%esp
801056d2:	85 c0                	test   %eax,%eax
801056d4:	0f 84 46 01 00 00    	je     80105820 <create+0x170>
    return 0;
  ilock(dp);
801056da:	83 ec 0c             	sub    $0xc,%esp
801056dd:	89 c3                	mov    %eax,%ebx
801056df:	50                   	push   %eax
801056e0:	e8 9b bf ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801056e5:	83 c4 0c             	add    $0xc,%esp
801056e8:	6a 00                	push   $0x0
801056ea:	56                   	push   %esi
801056eb:	53                   	push   %ebx
801056ec:	e8 bf c4 ff ff       	call   80101bb0 <dirlookup>
801056f1:	83 c4 10             	add    $0x10,%esp
801056f4:	85 c0                	test   %eax,%eax
801056f6:	89 c7                	mov    %eax,%edi
801056f8:	74 36                	je     80105730 <create+0x80>
    iunlockput(dp);
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	53                   	push   %ebx
801056fe:	e8 0d c2 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105703:	89 3c 24             	mov    %edi,(%esp)
80105706:	e8 75 bf ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010570b:	83 c4 10             	add    $0x10,%esp
8010570e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105713:	0f 85 97 00 00 00    	jne    801057b0 <create+0x100>
80105719:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010571e:	0f 85 8c 00 00 00    	jne    801057b0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105724:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105727:	89 f8                	mov    %edi,%eax
80105729:	5b                   	pop    %ebx
8010572a:	5e                   	pop    %esi
8010572b:	5f                   	pop    %edi
8010572c:	5d                   	pop    %ebp
8010572d:	c3                   	ret    
8010572e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105730:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105734:	83 ec 08             	sub    $0x8,%esp
80105737:	50                   	push   %eax
80105738:	ff 33                	pushl  (%ebx)
8010573a:	e8 d1 bd ff ff       	call   80101510 <ialloc>
8010573f:	83 c4 10             	add    $0x10,%esp
80105742:	85 c0                	test   %eax,%eax
80105744:	89 c7                	mov    %eax,%edi
80105746:	0f 84 e8 00 00 00    	je     80105834 <create+0x184>
  ilock(ip);
8010574c:	83 ec 0c             	sub    $0xc,%esp
8010574f:	50                   	push   %eax
80105750:	e8 2b bf ff ff       	call   80101680 <ilock>
  ip->major = major;
80105755:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105759:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010575d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105761:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105765:	b8 01 00 00 00       	mov    $0x1,%eax
8010576a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010576e:	89 3c 24             	mov    %edi,(%esp)
80105771:	e8 5a be ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010577e:	74 50                	je     801057d0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105780:	83 ec 04             	sub    $0x4,%esp
80105783:	ff 77 04             	pushl  0x4(%edi)
80105786:	56                   	push   %esi
80105787:	53                   	push   %ebx
80105788:	e8 93 c6 ff ff       	call   80101e20 <dirlink>
8010578d:	83 c4 10             	add    $0x10,%esp
80105790:	85 c0                	test   %eax,%eax
80105792:	0f 88 8f 00 00 00    	js     80105827 <create+0x177>
  iunlockput(dp);
80105798:	83 ec 0c             	sub    $0xc,%esp
8010579b:	53                   	push   %ebx
8010579c:	e8 6f c1 ff ff       	call   80101910 <iunlockput>
  return ip;
801057a1:	83 c4 10             	add    $0x10,%esp
}
801057a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057a7:	89 f8                	mov    %edi,%eax
801057a9:	5b                   	pop    %ebx
801057aa:	5e                   	pop    %esi
801057ab:	5f                   	pop    %edi
801057ac:	5d                   	pop    %ebp
801057ad:	c3                   	ret    
801057ae:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	57                   	push   %edi
    return 0;
801057b4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801057b6:	e8 55 c1 ff ff       	call   80101910 <iunlockput>
    return 0;
801057bb:	83 c4 10             	add    $0x10,%esp
}
801057be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c1:	89 f8                	mov    %edi,%eax
801057c3:	5b                   	pop    %ebx
801057c4:	5e                   	pop    %esi
801057c5:	5f                   	pop    %edi
801057c6:	5d                   	pop    %ebp
801057c7:	c3                   	ret    
801057c8:	90                   	nop
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801057d0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801057d5:	83 ec 0c             	sub    $0xc,%esp
801057d8:	53                   	push   %ebx
801057d9:	e8 f2 bd ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057de:	83 c4 0c             	add    $0xc,%esp
801057e1:	ff 77 04             	pushl  0x4(%edi)
801057e4:	68 e7 84 10 80       	push   $0x801084e7
801057e9:	57                   	push   %edi
801057ea:	e8 31 c6 ff ff       	call   80101e20 <dirlink>
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	85 c0                	test   %eax,%eax
801057f4:	78 1c                	js     80105812 <create+0x162>
801057f6:	83 ec 04             	sub    $0x4,%esp
801057f9:	ff 73 04             	pushl  0x4(%ebx)
801057fc:	68 0b 87 10 80       	push   $0x8010870b
80105801:	57                   	push   %edi
80105802:	e8 19 c6 ff ff       	call   80101e20 <dirlink>
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	85 c0                	test   %eax,%eax
8010580c:	0f 89 6e ff ff ff    	jns    80105780 <create+0xd0>
      panic("create dots");
80105812:	83 ec 0c             	sub    $0xc,%esp
80105815:	68 ff 86 10 80       	push   $0x801086ff
8010581a:	e8 71 ab ff ff       	call   80100390 <panic>
8010581f:	90                   	nop
    return 0;
80105820:	31 ff                	xor    %edi,%edi
80105822:	e9 fd fe ff ff       	jmp    80105724 <create+0x74>
    panic("create: dirlink");
80105827:	83 ec 0c             	sub    $0xc,%esp
8010582a:	68 0e 87 10 80       	push   $0x8010870e
8010582f:	e8 5c ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	68 f0 86 10 80       	push   $0x801086f0
8010583c:	e8 4f ab ff ff       	call   80100390 <panic>
80105841:	eb 0d                	jmp    80105850 <argfd.constprop.0>
80105843:	90                   	nop
80105844:	90                   	nop
80105845:	90                   	nop
80105846:	90                   	nop
80105847:	90                   	nop
80105848:	90                   	nop
80105849:	90                   	nop
8010584a:	90                   	nop
8010584b:	90                   	nop
8010584c:	90                   	nop
8010584d:	90                   	nop
8010584e:	90                   	nop
8010584f:	90                   	nop

80105850 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	56                   	push   %esi
80105854:	53                   	push   %ebx
80105855:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105857:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010585a:	89 d6                	mov    %edx,%esi
8010585c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010585f:	50                   	push   %eax
80105860:	6a 00                	push   $0x0
80105862:	e8 f9 fc ff ff       	call   80105560 <argint>
80105867:	83 c4 10             	add    $0x10,%esp
8010586a:	85 c0                	test   %eax,%eax
8010586c:	78 2a                	js     80105898 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010586e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105872:	77 24                	ja     80105898 <argfd.constprop.0+0x48>
80105874:	e8 f7 e4 ff ff       	call   80103d70 <myproc>
80105879:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010587c:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80105880:	85 c0                	test   %eax,%eax
80105882:	74 14                	je     80105898 <argfd.constprop.0+0x48>
  if(pfd)
80105884:	85 db                	test   %ebx,%ebx
80105886:	74 02                	je     8010588a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105888:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010588a:	89 06                	mov    %eax,(%esi)
  return 0;
8010588c:	31 c0                	xor    %eax,%eax
}
8010588e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105891:	5b                   	pop    %ebx
80105892:	5e                   	pop    %esi
80105893:	5d                   	pop    %ebp
80105894:	c3                   	ret    
80105895:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589d:	eb ef                	jmp    8010588e <argfd.constprop.0+0x3e>
8010589f:	90                   	nop

801058a0 <sys_dup>:
{
801058a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801058a1:	31 c0                	xor    %eax,%eax
{
801058a3:	89 e5                	mov    %esp,%ebp
801058a5:	56                   	push   %esi
801058a6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801058a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801058aa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801058ad:	e8 9e ff ff ff       	call   80105850 <argfd.constprop.0>
801058b2:	85 c0                	test   %eax,%eax
801058b4:	78 42                	js     801058f8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801058b6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058b9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058bb:	e8 b0 e4 ff ff       	call   80103d70 <myproc>
801058c0:	eb 0e                	jmp    801058d0 <sys_dup+0x30>
801058c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058c8:	83 c3 01             	add    $0x1,%ebx
801058cb:	83 fb 10             	cmp    $0x10,%ebx
801058ce:	74 28                	je     801058f8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801058d0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801058d4:	85 d2                	test   %edx,%edx
801058d6:	75 f0                	jne    801058c8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801058d8:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
801058dc:	83 ec 0c             	sub    $0xc,%esp
801058df:	ff 75 f4             	pushl  -0xc(%ebp)
801058e2:	e8 09 b5 ff ff       	call   80100df0 <filedup>
  return fd;
801058e7:	83 c4 10             	add    $0x10,%esp
}
801058ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058ed:	89 d8                	mov    %ebx,%eax
801058ef:	5b                   	pop    %ebx
801058f0:	5e                   	pop    %esi
801058f1:	5d                   	pop    %ebp
801058f2:	c3                   	ret    
801058f3:	90                   	nop
801058f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801058fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105900:	89 d8                	mov    %ebx,%eax
80105902:	5b                   	pop    %ebx
80105903:	5e                   	pop    %esi
80105904:	5d                   	pop    %ebp
80105905:	c3                   	ret    
80105906:	8d 76 00             	lea    0x0(%esi),%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105910 <sys_read>:
{
80105910:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105911:	31 c0                	xor    %eax,%eax
{
80105913:	89 e5                	mov    %esp,%ebp
80105915:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105918:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010591b:	e8 30 ff ff ff       	call   80105850 <argfd.constprop.0>
80105920:	85 c0                	test   %eax,%eax
80105922:	78 4c                	js     80105970 <sys_read+0x60>
80105924:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105927:	83 ec 08             	sub    $0x8,%esp
8010592a:	50                   	push   %eax
8010592b:	6a 02                	push   $0x2
8010592d:	e8 2e fc ff ff       	call   80105560 <argint>
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	85 c0                	test   %eax,%eax
80105937:	78 37                	js     80105970 <sys_read+0x60>
80105939:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010593c:	83 ec 04             	sub    $0x4,%esp
8010593f:	ff 75 f0             	pushl  -0x10(%ebp)
80105942:	50                   	push   %eax
80105943:	6a 01                	push   $0x1
80105945:	e8 66 fc ff ff       	call   801055b0 <argptr>
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	85 c0                	test   %eax,%eax
8010594f:	78 1f                	js     80105970 <sys_read+0x60>
  return fileread(f, p, n);
80105951:	83 ec 04             	sub    $0x4,%esp
80105954:	ff 75 f0             	pushl  -0x10(%ebp)
80105957:	ff 75 f4             	pushl  -0xc(%ebp)
8010595a:	ff 75 ec             	pushl  -0x14(%ebp)
8010595d:	e8 fe b5 ff ff       	call   80100f60 <fileread>
80105962:	83 c4 10             	add    $0x10,%esp
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105975:	c9                   	leave  
80105976:	c3                   	ret    
80105977:	89 f6                	mov    %esi,%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105980 <sys_write>:
{
80105980:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105981:	31 c0                	xor    %eax,%eax
{
80105983:	89 e5                	mov    %esp,%ebp
80105985:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105988:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010598b:	e8 c0 fe ff ff       	call   80105850 <argfd.constprop.0>
80105990:	85 c0                	test   %eax,%eax
80105992:	78 4c                	js     801059e0 <sys_write+0x60>
80105994:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105997:	83 ec 08             	sub    $0x8,%esp
8010599a:	50                   	push   %eax
8010599b:	6a 02                	push   $0x2
8010599d:	e8 be fb ff ff       	call   80105560 <argint>
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	85 c0                	test   %eax,%eax
801059a7:	78 37                	js     801059e0 <sys_write+0x60>
801059a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ac:	83 ec 04             	sub    $0x4,%esp
801059af:	ff 75 f0             	pushl  -0x10(%ebp)
801059b2:	50                   	push   %eax
801059b3:	6a 01                	push   $0x1
801059b5:	e8 f6 fb ff ff       	call   801055b0 <argptr>
801059ba:	83 c4 10             	add    $0x10,%esp
801059bd:	85 c0                	test   %eax,%eax
801059bf:	78 1f                	js     801059e0 <sys_write+0x60>
  return filewrite(f, p, n);
801059c1:	83 ec 04             	sub    $0x4,%esp
801059c4:	ff 75 f0             	pushl  -0x10(%ebp)
801059c7:	ff 75 f4             	pushl  -0xc(%ebp)
801059ca:	ff 75 ec             	pushl  -0x14(%ebp)
801059cd:	e8 1e b6 ff ff       	call   80100ff0 <filewrite>
801059d2:	83 c4 10             	add    $0x10,%esp
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801059e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <sys_close>:
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801059f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801059f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059fc:	e8 4f fe ff ff       	call   80105850 <argfd.constprop.0>
80105a01:	85 c0                	test   %eax,%eax
80105a03:	78 2b                	js     80105a30 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105a05:	e8 66 e3 ff ff       	call   80103d70 <myproc>
80105a0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105a0d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105a10:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80105a17:	00 
  fileclose(f);
80105a18:	ff 75 f4             	pushl  -0xc(%ebp)
80105a1b:	e8 20 b4 ff ff       	call   80100e40 <fileclose>
  return 0;
80105a20:	83 c4 10             	add    $0x10,%esp
80105a23:	31 c0                	xor    %eax,%eax
}
80105a25:	c9                   	leave  
80105a26:	c3                   	ret    
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a40 <sys_fstat>:
{
80105a40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a41:	31 c0                	xor    %eax,%eax
{
80105a43:	89 e5                	mov    %esp,%ebp
80105a45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a48:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105a4b:	e8 00 fe ff ff       	call   80105850 <argfd.constprop.0>
80105a50:	85 c0                	test   %eax,%eax
80105a52:	78 2c                	js     80105a80 <sys_fstat+0x40>
80105a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a57:	83 ec 04             	sub    $0x4,%esp
80105a5a:	6a 14                	push   $0x14
80105a5c:	50                   	push   %eax
80105a5d:	6a 01                	push   $0x1
80105a5f:	e8 4c fb ff ff       	call   801055b0 <argptr>
80105a64:	83 c4 10             	add    $0x10,%esp
80105a67:	85 c0                	test   %eax,%eax
80105a69:	78 15                	js     80105a80 <sys_fstat+0x40>
  return filestat(f, st);
80105a6b:	83 ec 08             	sub    $0x8,%esp
80105a6e:	ff 75 f4             	pushl  -0xc(%ebp)
80105a71:	ff 75 f0             	pushl  -0x10(%ebp)
80105a74:	e8 97 b4 ff ff       	call   80100f10 <filestat>
80105a79:	83 c4 10             	add    $0x10,%esp
}
80105a7c:	c9                   	leave  
80105a7d:	c3                   	ret    
80105a7e:	66 90                	xchg   %ax,%ax
    return -1;
80105a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a85:	c9                   	leave  
80105a86:	c3                   	ret    
80105a87:	89 f6                	mov    %esi,%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a90 <sys_link>:
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	57                   	push   %edi
80105a94:	56                   	push   %esi
80105a95:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a96:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105a99:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a9c:	50                   	push   %eax
80105a9d:	6a 00                	push   $0x0
80105a9f:	e8 6c fb ff ff       	call   80105610 <argstr>
80105aa4:	83 c4 10             	add    $0x10,%esp
80105aa7:	85 c0                	test   %eax,%eax
80105aa9:	0f 88 fb 00 00 00    	js     80105baa <sys_link+0x11a>
80105aaf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105ab2:	83 ec 08             	sub    $0x8,%esp
80105ab5:	50                   	push   %eax
80105ab6:	6a 01                	push   $0x1
80105ab8:	e8 53 fb ff ff       	call   80105610 <argstr>
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	85 c0                	test   %eax,%eax
80105ac2:	0f 88 e2 00 00 00    	js     80105baa <sys_link+0x11a>
  begin_op();
80105ac8:	e8 d3 d0 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	ff 75 d4             	pushl  -0x2c(%ebp)
80105ad3:	e8 08 c4 ff ff       	call   80101ee0 <namei>
80105ad8:	83 c4 10             	add    $0x10,%esp
80105adb:	85 c0                	test   %eax,%eax
80105add:	89 c3                	mov    %eax,%ebx
80105adf:	0f 84 ea 00 00 00    	je     80105bcf <sys_link+0x13f>
  ilock(ip);
80105ae5:	83 ec 0c             	sub    $0xc,%esp
80105ae8:	50                   	push   %eax
80105ae9:	e8 92 bb ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80105aee:	83 c4 10             	add    $0x10,%esp
80105af1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105af6:	0f 84 bb 00 00 00    	je     80105bb7 <sys_link+0x127>
  ip->nlink++;
80105afc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b01:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105b04:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105b07:	53                   	push   %ebx
80105b08:	e8 c3 ba ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80105b0d:	89 1c 24             	mov    %ebx,(%esp)
80105b10:	e8 4b bc ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105b15:	58                   	pop    %eax
80105b16:	5a                   	pop    %edx
80105b17:	57                   	push   %edi
80105b18:	ff 75 d0             	pushl  -0x30(%ebp)
80105b1b:	e8 e0 c3 ff ff       	call   80101f00 <nameiparent>
80105b20:	83 c4 10             	add    $0x10,%esp
80105b23:	85 c0                	test   %eax,%eax
80105b25:	89 c6                	mov    %eax,%esi
80105b27:	74 5b                	je     80105b84 <sys_link+0xf4>
  ilock(dp);
80105b29:	83 ec 0c             	sub    $0xc,%esp
80105b2c:	50                   	push   %eax
80105b2d:	e8 4e bb ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b32:	83 c4 10             	add    $0x10,%esp
80105b35:	8b 03                	mov    (%ebx),%eax
80105b37:	39 06                	cmp    %eax,(%esi)
80105b39:	75 3d                	jne    80105b78 <sys_link+0xe8>
80105b3b:	83 ec 04             	sub    $0x4,%esp
80105b3e:	ff 73 04             	pushl  0x4(%ebx)
80105b41:	57                   	push   %edi
80105b42:	56                   	push   %esi
80105b43:	e8 d8 c2 ff ff       	call   80101e20 <dirlink>
80105b48:	83 c4 10             	add    $0x10,%esp
80105b4b:	85 c0                	test   %eax,%eax
80105b4d:	78 29                	js     80105b78 <sys_link+0xe8>
  iunlockput(dp);
80105b4f:	83 ec 0c             	sub    $0xc,%esp
80105b52:	56                   	push   %esi
80105b53:	e8 b8 bd ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105b58:	89 1c 24             	mov    %ebx,(%esp)
80105b5b:	e8 50 bc ff ff       	call   801017b0 <iput>
  end_op();
80105b60:	e8 ab d0 ff ff       	call   80102c10 <end_op>
  return 0;
80105b65:	83 c4 10             	add    $0x10,%esp
80105b68:	31 c0                	xor    %eax,%eax
}
80105b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b6d:	5b                   	pop    %ebx
80105b6e:	5e                   	pop    %esi
80105b6f:	5f                   	pop    %edi
80105b70:	5d                   	pop    %ebp
80105b71:	c3                   	ret    
80105b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105b78:	83 ec 0c             	sub    $0xc,%esp
80105b7b:	56                   	push   %esi
80105b7c:	e8 8f bd ff ff       	call   80101910 <iunlockput>
    goto bad;
80105b81:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	53                   	push   %ebx
80105b88:	e8 f3 ba ff ff       	call   80101680 <ilock>
  ip->nlink--;
80105b8d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b92:	89 1c 24             	mov    %ebx,(%esp)
80105b95:	e8 36 ba ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105b9a:	89 1c 24             	mov    %ebx,(%esp)
80105b9d:	e8 6e bd ff ff       	call   80101910 <iunlockput>
  end_op();
80105ba2:	e8 69 d0 ff ff       	call   80102c10 <end_op>
  return -1;
80105ba7:	83 c4 10             	add    $0x10,%esp
}
80105baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105bad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bb2:	5b                   	pop    %ebx
80105bb3:	5e                   	pop    %esi
80105bb4:	5f                   	pop    %edi
80105bb5:	5d                   	pop    %ebp
80105bb6:	c3                   	ret    
    iunlockput(ip);
80105bb7:	83 ec 0c             	sub    $0xc,%esp
80105bba:	53                   	push   %ebx
80105bbb:	e8 50 bd ff ff       	call   80101910 <iunlockput>
    end_op();
80105bc0:	e8 4b d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105bc5:	83 c4 10             	add    $0x10,%esp
80105bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bcd:	eb 9b                	jmp    80105b6a <sys_link+0xda>
    end_op();
80105bcf:	e8 3c d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105bd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd9:	eb 8f                	jmp    80105b6a <sys_link+0xda>
80105bdb:	90                   	nop
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105be0 <sys_unlink>:
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	57                   	push   %edi
80105be4:	56                   	push   %esi
80105be5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105be6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105be9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105bec:	50                   	push   %eax
80105bed:	6a 00                	push   $0x0
80105bef:	e8 1c fa ff ff       	call   80105610 <argstr>
80105bf4:	83 c4 10             	add    $0x10,%esp
80105bf7:	85 c0                	test   %eax,%eax
80105bf9:	0f 88 77 01 00 00    	js     80105d76 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105bff:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105c02:	e8 99 cf ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c07:	83 ec 08             	sub    $0x8,%esp
80105c0a:	53                   	push   %ebx
80105c0b:	ff 75 c0             	pushl  -0x40(%ebp)
80105c0e:	e8 ed c2 ff ff       	call   80101f00 <nameiparent>
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	85 c0                	test   %eax,%eax
80105c18:	89 c6                	mov    %eax,%esi
80105c1a:	0f 84 60 01 00 00    	je     80105d80 <sys_unlink+0x1a0>
  ilock(dp);
80105c20:	83 ec 0c             	sub    $0xc,%esp
80105c23:	50                   	push   %eax
80105c24:	e8 57 ba ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c29:	58                   	pop    %eax
80105c2a:	5a                   	pop    %edx
80105c2b:	68 e7 84 10 80       	push   $0x801084e7
80105c30:	53                   	push   %ebx
80105c31:	e8 5a bf ff ff       	call   80101b90 <namecmp>
80105c36:	83 c4 10             	add    $0x10,%esp
80105c39:	85 c0                	test   %eax,%eax
80105c3b:	0f 84 03 01 00 00    	je     80105d44 <sys_unlink+0x164>
80105c41:	83 ec 08             	sub    $0x8,%esp
80105c44:	68 0b 87 10 80       	push   $0x8010870b
80105c49:	53                   	push   %ebx
80105c4a:	e8 41 bf ff ff       	call   80101b90 <namecmp>
80105c4f:	83 c4 10             	add    $0x10,%esp
80105c52:	85 c0                	test   %eax,%eax
80105c54:	0f 84 ea 00 00 00    	je     80105d44 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105c5a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c5d:	83 ec 04             	sub    $0x4,%esp
80105c60:	50                   	push   %eax
80105c61:	53                   	push   %ebx
80105c62:	56                   	push   %esi
80105c63:	e8 48 bf ff ff       	call   80101bb0 <dirlookup>
80105c68:	83 c4 10             	add    $0x10,%esp
80105c6b:	85 c0                	test   %eax,%eax
80105c6d:	89 c3                	mov    %eax,%ebx
80105c6f:	0f 84 cf 00 00 00    	je     80105d44 <sys_unlink+0x164>
  ilock(ip);
80105c75:	83 ec 0c             	sub    $0xc,%esp
80105c78:	50                   	push   %eax
80105c79:	e8 02 ba ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
80105c7e:	83 c4 10             	add    $0x10,%esp
80105c81:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c86:	0f 8e 10 01 00 00    	jle    80105d9c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c8c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c91:	74 6d                	je     80105d00 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105c93:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c96:	83 ec 04             	sub    $0x4,%esp
80105c99:	6a 10                	push   $0x10
80105c9b:	6a 00                	push   $0x0
80105c9d:	50                   	push   %eax
80105c9e:	e8 bd f5 ff ff       	call   80105260 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ca3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ca6:	6a 10                	push   $0x10
80105ca8:	ff 75 c4             	pushl  -0x3c(%ebp)
80105cab:	50                   	push   %eax
80105cac:	56                   	push   %esi
80105cad:	e8 ae bd ff ff       	call   80101a60 <writei>
80105cb2:	83 c4 20             	add    $0x20,%esp
80105cb5:	83 f8 10             	cmp    $0x10,%eax
80105cb8:	0f 85 eb 00 00 00    	jne    80105da9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105cbe:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cc3:	0f 84 97 00 00 00    	je     80105d60 <sys_unlink+0x180>
  iunlockput(dp);
80105cc9:	83 ec 0c             	sub    $0xc,%esp
80105ccc:	56                   	push   %esi
80105ccd:	e8 3e bc ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105cd2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105cd7:	89 1c 24             	mov    %ebx,(%esp)
80105cda:	e8 f1 b8 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105cdf:	89 1c 24             	mov    %ebx,(%esp)
80105ce2:	e8 29 bc ff ff       	call   80101910 <iunlockput>
  end_op();
80105ce7:	e8 24 cf ff ff       	call   80102c10 <end_op>
  return 0;
80105cec:	83 c4 10             	add    $0x10,%esp
80105cef:	31 c0                	xor    %eax,%eax
}
80105cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cf4:	5b                   	pop    %ebx
80105cf5:	5e                   	pop    %esi
80105cf6:	5f                   	pop    %edi
80105cf7:	5d                   	pop    %ebp
80105cf8:	c3                   	ret    
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d00:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105d04:	76 8d                	jbe    80105c93 <sys_unlink+0xb3>
80105d06:	bf 20 00 00 00       	mov    $0x20,%edi
80105d0b:	eb 0f                	jmp    80105d1c <sys_unlink+0x13c>
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
80105d10:	83 c7 10             	add    $0x10,%edi
80105d13:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105d16:	0f 83 77 ff ff ff    	jae    80105c93 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d1c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d1f:	6a 10                	push   $0x10
80105d21:	57                   	push   %edi
80105d22:	50                   	push   %eax
80105d23:	53                   	push   %ebx
80105d24:	e8 37 bc ff ff       	call   80101960 <readi>
80105d29:	83 c4 10             	add    $0x10,%esp
80105d2c:	83 f8 10             	cmp    $0x10,%eax
80105d2f:	75 5e                	jne    80105d8f <sys_unlink+0x1af>
    if(de.inum != 0)
80105d31:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105d36:	74 d8                	je     80105d10 <sys_unlink+0x130>
    iunlockput(ip);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	53                   	push   %ebx
80105d3c:	e8 cf bb ff ff       	call   80101910 <iunlockput>
    goto bad;
80105d41:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105d44:	83 ec 0c             	sub    $0xc,%esp
80105d47:	56                   	push   %esi
80105d48:	e8 c3 bb ff ff       	call   80101910 <iunlockput>
  end_op();
80105d4d:	e8 be ce ff ff       	call   80102c10 <end_op>
  return -1;
80105d52:	83 c4 10             	add    $0x10,%esp
80105d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5a:	eb 95                	jmp    80105cf1 <sys_unlink+0x111>
80105d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105d60:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105d65:	83 ec 0c             	sub    $0xc,%esp
80105d68:	56                   	push   %esi
80105d69:	e8 62 b8 ff ff       	call   801015d0 <iupdate>
80105d6e:	83 c4 10             	add    $0x10,%esp
80105d71:	e9 53 ff ff ff       	jmp    80105cc9 <sys_unlink+0xe9>
    return -1;
80105d76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7b:	e9 71 ff ff ff       	jmp    80105cf1 <sys_unlink+0x111>
    end_op();
80105d80:	e8 8b ce ff ff       	call   80102c10 <end_op>
    return -1;
80105d85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8a:	e9 62 ff ff ff       	jmp    80105cf1 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105d8f:	83 ec 0c             	sub    $0xc,%esp
80105d92:	68 30 87 10 80       	push   $0x80108730
80105d97:	e8 f4 a5 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105d9c:	83 ec 0c             	sub    $0xc,%esp
80105d9f:	68 1e 87 10 80       	push   $0x8010871e
80105da4:	e8 e7 a5 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105da9:	83 ec 0c             	sub    $0xc,%esp
80105dac:	68 42 87 10 80       	push   $0x80108742
80105db1:	e8 da a5 ff ff       	call   80100390 <panic>
80105db6:	8d 76 00             	lea    0x0(%esi),%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dc0 <sys_open>:

int
sys_open(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	57                   	push   %edi
80105dc4:	56                   	push   %esi
80105dc5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dc6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105dc9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dcc:	50                   	push   %eax
80105dcd:	6a 00                	push   $0x0
80105dcf:	e8 3c f8 ff ff       	call   80105610 <argstr>
80105dd4:	83 c4 10             	add    $0x10,%esp
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 88 1d 01 00 00    	js     80105efc <sys_open+0x13c>
80105ddf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105de2:	83 ec 08             	sub    $0x8,%esp
80105de5:	50                   	push   %eax
80105de6:	6a 01                	push   $0x1
80105de8:	e8 73 f7 ff ff       	call   80105560 <argint>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	85 c0                	test   %eax,%eax
80105df2:	0f 88 04 01 00 00    	js     80105efc <sys_open+0x13c>
    return -1;

  begin_op();
80105df8:	e8 a3 cd ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
80105dfd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105e01:	0f 85 a9 00 00 00    	jne    80105eb0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105e07:	83 ec 0c             	sub    $0xc,%esp
80105e0a:	ff 75 e0             	pushl  -0x20(%ebp)
80105e0d:	e8 ce c0 ff ff       	call   80101ee0 <namei>
80105e12:	83 c4 10             	add    $0x10,%esp
80105e15:	85 c0                	test   %eax,%eax
80105e17:	89 c6                	mov    %eax,%esi
80105e19:	0f 84 b2 00 00 00    	je     80105ed1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105e1f:	83 ec 0c             	sub    $0xc,%esp
80105e22:	50                   	push   %eax
80105e23:	e8 58 b8 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e28:	83 c4 10             	add    $0x10,%esp
80105e2b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105e30:	0f 84 aa 00 00 00    	je     80105ee0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e36:	e8 45 af ff ff       	call   80100d80 <filealloc>
80105e3b:	85 c0                	test   %eax,%eax
80105e3d:	89 c7                	mov    %eax,%edi
80105e3f:	0f 84 a6 00 00 00    	je     80105eeb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105e45:	e8 26 df ff ff       	call   80103d70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e4a:	31 db                	xor    %ebx,%ebx
80105e4c:	eb 0e                	jmp    80105e5c <sys_open+0x9c>
80105e4e:	66 90                	xchg   %ax,%ax
80105e50:	83 c3 01             	add    $0x1,%ebx
80105e53:	83 fb 10             	cmp    $0x10,%ebx
80105e56:	0f 84 ac 00 00 00    	je     80105f08 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105e5c:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105e60:	85 d2                	test   %edx,%edx
80105e62:	75 ec                	jne    80105e50 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e64:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e67:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
80105e6b:	56                   	push   %esi
80105e6c:	e8 ef b8 ff ff       	call   80101760 <iunlock>
  end_op();
80105e71:	e8 9a cd ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105e76:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e7f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e82:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105e85:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e8c:	89 d0                	mov    %edx,%eax
80105e8e:	f7 d0                	not    %eax
80105e90:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e93:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105e96:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e99:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea0:	89 d8                	mov    %ebx,%eax
80105ea2:	5b                   	pop    %ebx
80105ea3:	5e                   	pop    %esi
80105ea4:	5f                   	pop    %edi
80105ea5:	5d                   	pop    %ebp
80105ea6:	c3                   	ret    
80105ea7:	89 f6                	mov    %esi,%esi
80105ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105eb6:	31 c9                	xor    %ecx,%ecx
80105eb8:	6a 00                	push   $0x0
80105eba:	ba 02 00 00 00       	mov    $0x2,%edx
80105ebf:	e8 ec f7 ff ff       	call   801056b0 <create>
    if(ip == 0){
80105ec4:	83 c4 10             	add    $0x10,%esp
80105ec7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105ec9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ecb:	0f 85 65 ff ff ff    	jne    80105e36 <sys_open+0x76>
      end_op();
80105ed1:	e8 3a cd ff ff       	call   80102c10 <end_op>
      return -1;
80105ed6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105edb:	eb c0                	jmp    80105e9d <sys_open+0xdd>
80105edd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ee0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ee3:	85 c9                	test   %ecx,%ecx
80105ee5:	0f 84 4b ff ff ff    	je     80105e36 <sys_open+0x76>
    iunlockput(ip);
80105eeb:	83 ec 0c             	sub    $0xc,%esp
80105eee:	56                   	push   %esi
80105eef:	e8 1c ba ff ff       	call   80101910 <iunlockput>
    end_op();
80105ef4:	e8 17 cd ff ff       	call   80102c10 <end_op>
    return -1;
80105ef9:	83 c4 10             	add    $0x10,%esp
80105efc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f01:	eb 9a                	jmp    80105e9d <sys_open+0xdd>
80105f03:	90                   	nop
80105f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105f08:	83 ec 0c             	sub    $0xc,%esp
80105f0b:	57                   	push   %edi
80105f0c:	e8 2f af ff ff       	call   80100e40 <fileclose>
80105f11:	83 c4 10             	add    $0x10,%esp
80105f14:	eb d5                	jmp    80105eeb <sys_open+0x12b>
80105f16:	8d 76 00             	lea    0x0(%esi),%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f20 <sys_mkdir>:

int
sys_mkdir(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105f26:	e8 75 cc ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f2e:	83 ec 08             	sub    $0x8,%esp
80105f31:	50                   	push   %eax
80105f32:	6a 00                	push   $0x0
80105f34:	e8 d7 f6 ff ff       	call   80105610 <argstr>
80105f39:	83 c4 10             	add    $0x10,%esp
80105f3c:	85 c0                	test   %eax,%eax
80105f3e:	78 30                	js     80105f70 <sys_mkdir+0x50>
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f46:	31 c9                	xor    %ecx,%ecx
80105f48:	6a 00                	push   $0x0
80105f4a:	ba 01 00 00 00       	mov    $0x1,%edx
80105f4f:	e8 5c f7 ff ff       	call   801056b0 <create>
80105f54:	83 c4 10             	add    $0x10,%esp
80105f57:	85 c0                	test   %eax,%eax
80105f59:	74 15                	je     80105f70 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f5b:	83 ec 0c             	sub    $0xc,%esp
80105f5e:	50                   	push   %eax
80105f5f:	e8 ac b9 ff ff       	call   80101910 <iunlockput>
  end_op();
80105f64:	e8 a7 cc ff ff       	call   80102c10 <end_op>
  return 0;
80105f69:	83 c4 10             	add    $0x10,%esp
80105f6c:	31 c0                	xor    %eax,%eax
}
80105f6e:	c9                   	leave  
80105f6f:	c3                   	ret    
    end_op();
80105f70:	e8 9b cc ff ff       	call   80102c10 <end_op>
    return -1;
80105f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f7a:	c9                   	leave  
80105f7b:	c3                   	ret    
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f80 <sys_mknod>:

int
sys_mknod(void)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f86:	e8 15 cc ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f8e:	83 ec 08             	sub    $0x8,%esp
80105f91:	50                   	push   %eax
80105f92:	6a 00                	push   $0x0
80105f94:	e8 77 f6 ff ff       	call   80105610 <argstr>
80105f99:	83 c4 10             	add    $0x10,%esp
80105f9c:	85 c0                	test   %eax,%eax
80105f9e:	78 60                	js     80106000 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105fa0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fa3:	83 ec 08             	sub    $0x8,%esp
80105fa6:	50                   	push   %eax
80105fa7:	6a 01                	push   $0x1
80105fa9:	e8 b2 f5 ff ff       	call   80105560 <argint>
  if((argstr(0, &path)) < 0 ||
80105fae:	83 c4 10             	add    $0x10,%esp
80105fb1:	85 c0                	test   %eax,%eax
80105fb3:	78 4b                	js     80106000 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105fb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fb8:	83 ec 08             	sub    $0x8,%esp
80105fbb:	50                   	push   %eax
80105fbc:	6a 02                	push   $0x2
80105fbe:	e8 9d f5 ff ff       	call   80105560 <argint>
     argint(1, &major) < 0 ||
80105fc3:	83 c4 10             	add    $0x10,%esp
80105fc6:	85 c0                	test   %eax,%eax
80105fc8:	78 36                	js     80106000 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105fca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105fce:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105fd1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105fd5:	ba 03 00 00 00       	mov    $0x3,%edx
80105fda:	50                   	push   %eax
80105fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105fde:	e8 cd f6 ff ff       	call   801056b0 <create>
80105fe3:	83 c4 10             	add    $0x10,%esp
80105fe6:	85 c0                	test   %eax,%eax
80105fe8:	74 16                	je     80106000 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105fea:	83 ec 0c             	sub    $0xc,%esp
80105fed:	50                   	push   %eax
80105fee:	e8 1d b9 ff ff       	call   80101910 <iunlockput>
  end_op();
80105ff3:	e8 18 cc ff ff       	call   80102c10 <end_op>
  return 0;
80105ff8:	83 c4 10             	add    $0x10,%esp
80105ffb:	31 c0                	xor    %eax,%eax
}
80105ffd:	c9                   	leave  
80105ffe:	c3                   	ret    
80105fff:	90                   	nop
    end_op();
80106000:	e8 0b cc ff ff       	call   80102c10 <end_op>
    return -1;
80106005:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010600a:	c9                   	leave  
8010600b:	c3                   	ret    
8010600c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106010 <sys_chdir>:

int
sys_chdir(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	56                   	push   %esi
80106014:	53                   	push   %ebx
80106015:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106018:	e8 53 dd ff ff       	call   80103d70 <myproc>
8010601d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010601f:	e8 7c cb ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106024:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106027:	83 ec 08             	sub    $0x8,%esp
8010602a:	50                   	push   %eax
8010602b:	6a 00                	push   $0x0
8010602d:	e8 de f5 ff ff       	call   80105610 <argstr>
80106032:	83 c4 10             	add    $0x10,%esp
80106035:	85 c0                	test   %eax,%eax
80106037:	78 77                	js     801060b0 <sys_chdir+0xa0>
80106039:	83 ec 0c             	sub    $0xc,%esp
8010603c:	ff 75 f4             	pushl  -0xc(%ebp)
8010603f:	e8 9c be ff ff       	call   80101ee0 <namei>
80106044:	83 c4 10             	add    $0x10,%esp
80106047:	85 c0                	test   %eax,%eax
80106049:	89 c3                	mov    %eax,%ebx
8010604b:	74 63                	je     801060b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010604d:	83 ec 0c             	sub    $0xc,%esp
80106050:	50                   	push   %eax
80106051:	e8 2a b6 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80106056:	83 c4 10             	add    $0x10,%esp
80106059:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010605e:	75 30                	jne    80106090 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106060:	83 ec 0c             	sub    $0xc,%esp
80106063:	53                   	push   %ebx
80106064:	e8 f7 b6 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80106069:	58                   	pop    %eax
8010606a:	ff 76 6c             	pushl  0x6c(%esi)
8010606d:	e8 3e b7 ff ff       	call   801017b0 <iput>
  end_op();
80106072:	e8 99 cb ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80106077:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010607a:	83 c4 10             	add    $0x10,%esp
8010607d:	31 c0                	xor    %eax,%eax
}
8010607f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106082:	5b                   	pop    %ebx
80106083:	5e                   	pop    %esi
80106084:	5d                   	pop    %ebp
80106085:	c3                   	ret    
80106086:	8d 76 00             	lea    0x0(%esi),%esi
80106089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	53                   	push   %ebx
80106094:	e8 77 b8 ff ff       	call   80101910 <iunlockput>
    end_op();
80106099:	e8 72 cb ff ff       	call   80102c10 <end_op>
    return -1;
8010609e:	83 c4 10             	add    $0x10,%esp
801060a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060a6:	eb d7                	jmp    8010607f <sys_chdir+0x6f>
801060a8:	90                   	nop
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801060b0:	e8 5b cb ff ff       	call   80102c10 <end_op>
    return -1;
801060b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ba:	eb c3                	jmp    8010607f <sys_chdir+0x6f>
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060c0 <sys_exec>:

int
sys_exec(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	57                   	push   %edi
801060c4:	56                   	push   %esi
801060c5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060c6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801060cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060d2:	50                   	push   %eax
801060d3:	6a 00                	push   $0x0
801060d5:	e8 36 f5 ff ff       	call   80105610 <argstr>
801060da:	83 c4 10             	add    $0x10,%esp
801060dd:	85 c0                	test   %eax,%eax
801060df:	0f 88 87 00 00 00    	js     8010616c <sys_exec+0xac>
801060e5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801060eb:	83 ec 08             	sub    $0x8,%esp
801060ee:	50                   	push   %eax
801060ef:	6a 01                	push   $0x1
801060f1:	e8 6a f4 ff ff       	call   80105560 <argint>
801060f6:	83 c4 10             	add    $0x10,%esp
801060f9:	85 c0                	test   %eax,%eax
801060fb:	78 6f                	js     8010616c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801060fd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106103:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106106:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106108:	68 80 00 00 00       	push   $0x80
8010610d:	6a 00                	push   $0x0
8010610f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106115:	50                   	push   %eax
80106116:	e8 45 f1 ff ff       	call   80105260 <memset>
8010611b:	83 c4 10             	add    $0x10,%esp
8010611e:	eb 2c                	jmp    8010614c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106120:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106126:	85 c0                	test   %eax,%eax
80106128:	74 56                	je     80106180 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010612a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106130:	83 ec 08             	sub    $0x8,%esp
80106133:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106136:	52                   	push   %edx
80106137:	50                   	push   %eax
80106138:	e8 b3 f3 ff ff       	call   801054f0 <fetchstr>
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	85 c0                	test   %eax,%eax
80106142:	78 28                	js     8010616c <sys_exec+0xac>
  for(i=0;; i++){
80106144:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106147:	83 fb 20             	cmp    $0x20,%ebx
8010614a:	74 20                	je     8010616c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010614c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106152:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106159:	83 ec 08             	sub    $0x8,%esp
8010615c:	57                   	push   %edi
8010615d:	01 f0                	add    %esi,%eax
8010615f:	50                   	push   %eax
80106160:	e8 4b f3 ff ff       	call   801054b0 <fetchint>
80106165:	83 c4 10             	add    $0x10,%esp
80106168:	85 c0                	test   %eax,%eax
8010616a:	79 b4                	jns    80106120 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010616c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010616f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106174:	5b                   	pop    %ebx
80106175:	5e                   	pop    %esi
80106176:	5f                   	pop    %edi
80106177:	5d                   	pop    %ebp
80106178:	c3                   	ret    
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106180:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106186:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106189:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106190:	00 00 00 00 
  return exec(path, argv);
80106194:	50                   	push   %eax
80106195:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010619b:	e8 70 a8 ff ff       	call   80100a10 <exec>
801061a0:	83 c4 10             	add    $0x10,%esp
}
801061a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a6:	5b                   	pop    %ebx
801061a7:	5e                   	pop    %esi
801061a8:	5f                   	pop    %edi
801061a9:	5d                   	pop    %ebp
801061aa:	c3                   	ret    
801061ab:	90                   	nop
801061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061b0 <sys_pipe>:

int
sys_pipe(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	57                   	push   %edi
801061b4:	56                   	push   %esi
801061b5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801061b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061bc:	6a 08                	push   $0x8
801061be:	50                   	push   %eax
801061bf:	6a 00                	push   $0x0
801061c1:	e8 ea f3 ff ff       	call   801055b0 <argptr>
801061c6:	83 c4 10             	add    $0x10,%esp
801061c9:	85 c0                	test   %eax,%eax
801061cb:	0f 88 ae 00 00 00    	js     8010627f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801061d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061d4:	83 ec 08             	sub    $0x8,%esp
801061d7:	50                   	push   %eax
801061d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061db:	50                   	push   %eax
801061dc:	e8 5f d0 ff ff       	call   80103240 <pipealloc>
801061e1:	83 c4 10             	add    $0x10,%esp
801061e4:	85 c0                	test   %eax,%eax
801061e6:	0f 88 93 00 00 00    	js     8010627f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801061ef:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801061f1:	e8 7a db ff ff       	call   80103d70 <myproc>
801061f6:	eb 10                	jmp    80106208 <sys_pipe+0x58>
801061f8:	90                   	nop
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106200:	83 c3 01             	add    $0x1,%ebx
80106203:	83 fb 10             	cmp    $0x10,%ebx
80106206:	74 60                	je     80106268 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106208:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
8010620c:	85 f6                	test   %esi,%esi
8010620e:	75 f0                	jne    80106200 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106210:	8d 73 08             	lea    0x8(%ebx),%esi
80106213:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106217:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010621a:	e8 51 db ff ff       	call   80103d70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010621f:	31 d2                	xor    %edx,%edx
80106221:	eb 0d                	jmp    80106230 <sys_pipe+0x80>
80106223:	90                   	nop
80106224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106228:	83 c2 01             	add    $0x1,%edx
8010622b:	83 fa 10             	cmp    $0x10,%edx
8010622e:	74 28                	je     80106258 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106230:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80106234:	85 c9                	test   %ecx,%ecx
80106236:	75 f0                	jne    80106228 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106238:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010623c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010623f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106241:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106244:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106247:	31 c0                	xor    %eax,%eax
}
80106249:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010624c:	5b                   	pop    %ebx
8010624d:	5e                   	pop    %esi
8010624e:	5f                   	pop    %edi
8010624f:	5d                   	pop    %ebp
80106250:	c3                   	ret    
80106251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106258:	e8 13 db ff ff       	call   80103d70 <myproc>
8010625d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80106264:	00 
80106265:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106268:	83 ec 0c             	sub    $0xc,%esp
8010626b:	ff 75 e0             	pushl  -0x20(%ebp)
8010626e:	e8 cd ab ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106273:	58                   	pop    %eax
80106274:	ff 75 e4             	pushl  -0x1c(%ebp)
80106277:	e8 c4 ab ff ff       	call   80100e40 <fileclose>
    return -1;
8010627c:	83 c4 10             	add    $0x10,%esp
8010627f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106284:	eb c3                	jmp    80106249 <sys_pipe+0x99>
80106286:	66 90                	xchg   %ax,%ax
80106288:	66 90                	xchg   %ax,%ax
8010628a:	66 90                	xchg   %ax,%ax
8010628c:	66 90                	xchg   %ax,%ax
8010628e:	66 90                	xchg   %ax,%ax

80106290 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106293:	5d                   	pop    %ebp
  return fork();
80106294:	e9 37 dd ff ff       	jmp    80103fd0 <fork>
80106299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062a0 <sys_exit>:

int
sys_exit(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801062a6:	e8 b5 e2 ff ff       	call   80104560 <exit>
  return 0;  // not reached
}
801062ab:	31 c0                	xor    %eax,%eax
801062ad:	c9                   	leave  
801062ae:	c3                   	ret    
801062af:	90                   	nop

801062b0 <sys_wait>:

int
sys_wait(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801062b3:	5d                   	pop    %ebp
  return wait();
801062b4:	e9 87 e5 ff ff       	jmp    80104840 <wait>
801062b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062c0 <sys_kill>:

int
sys_kill(void)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801062c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062c9:	50                   	push   %eax
801062ca:	6a 00                	push   $0x0
801062cc:	e8 8f f2 ff ff       	call   80105560 <argint>
801062d1:	83 c4 10             	add    $0x10,%esp
801062d4:	85 c0                	test   %eax,%eax
801062d6:	78 18                	js     801062f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801062d8:	83 ec 0c             	sub    $0xc,%esp
801062db:	ff 75 f4             	pushl  -0xc(%ebp)
801062de:	e8 cd e6 ff ff       	call   801049b0 <kill>
801062e3:	83 c4 10             	add    $0x10,%esp
}
801062e6:	c9                   	leave  
801062e7:	c3                   	ret    
801062e8:	90                   	nop
801062e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062f5:	c9                   	leave  
801062f6:	c3                   	ret    
801062f7:	89 f6                	mov    %esi,%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106300 <sys_getpid>:

int
sys_getpid(void)
{
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106306:	e8 65 da ff ff       	call   80103d70 <myproc>
8010630b:	8b 40 14             	mov    0x14(%eax),%eax
}
8010630e:	c9                   	leave  
8010630f:	c3                   	ret    

80106310 <sys_sbrk>:

int
sys_sbrk(void)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106314:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106317:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010631a:	50                   	push   %eax
8010631b:	6a 00                	push   $0x0
8010631d:	e8 3e f2 ff ff       	call   80105560 <argint>
80106322:	83 c4 10             	add    $0x10,%esp
80106325:	85 c0                	test   %eax,%eax
80106327:	78 27                	js     80106350 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106329:	e8 42 da ff ff       	call   80103d70 <myproc>
  if(growproc(n) < 0)
8010632e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106331:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106333:	ff 75 f4             	pushl  -0xc(%ebp)
80106336:	e8 d5 db ff ff       	call   80103f10 <growproc>
8010633b:	83 c4 10             	add    $0x10,%esp
8010633e:	85 c0                	test   %eax,%eax
80106340:	78 0e                	js     80106350 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106342:	89 d8                	mov    %ebx,%eax
80106344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106347:	c9                   	leave  
80106348:	c3                   	ret    
80106349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106350:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106355:	eb eb                	jmp    80106342 <sys_sbrk+0x32>
80106357:	89 f6                	mov    %esi,%esi
80106359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106360 <sys_sleep>:

int
sys_sleep(void)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106364:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106367:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010636a:	50                   	push   %eax
8010636b:	6a 00                	push   $0x0
8010636d:	e8 ee f1 ff ff       	call   80105560 <argint>
80106372:	83 c4 10             	add    $0x10,%esp
80106375:	85 c0                	test   %eax,%eax
80106377:	0f 88 8a 00 00 00    	js     80106407 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010637d:	83 ec 0c             	sub    $0xc,%esp
80106380:	68 c0 6b 11 80       	push   $0x80116bc0
80106385:	e8 c6 ed ff ff       	call   80105150 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010638a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010638d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106390:	8b 1d 00 74 11 80    	mov    0x80117400,%ebx
  while(ticks - ticks0 < n){
80106396:	85 d2                	test   %edx,%edx
80106398:	75 27                	jne    801063c1 <sys_sleep+0x61>
8010639a:	eb 54                	jmp    801063f0 <sys_sleep+0x90>
8010639c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801063a0:	83 ec 08             	sub    $0x8,%esp
801063a3:	68 c0 6b 11 80       	push   $0x80116bc0
801063a8:	68 00 74 11 80       	push   $0x80117400
801063ad:	e8 ce e3 ff ff       	call   80104780 <sleep>
  while(ticks - ticks0 < n){
801063b2:	a1 00 74 11 80       	mov    0x80117400,%eax
801063b7:	83 c4 10             	add    $0x10,%esp
801063ba:	29 d8                	sub    %ebx,%eax
801063bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801063bf:	73 2f                	jae    801063f0 <sys_sleep+0x90>
    if(myproc()->killed){
801063c1:	e8 aa d9 ff ff       	call   80103d70 <myproc>
801063c6:	8b 40 28             	mov    0x28(%eax),%eax
801063c9:	85 c0                	test   %eax,%eax
801063cb:	74 d3                	je     801063a0 <sys_sleep+0x40>
      release(&tickslock);
801063cd:	83 ec 0c             	sub    $0xc,%esp
801063d0:	68 c0 6b 11 80       	push   $0x80116bc0
801063d5:	e8 36 ee ff ff       	call   80105210 <release>
      return -1;
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801063e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063e5:	c9                   	leave  
801063e6:	c3                   	ret    
801063e7:	89 f6                	mov    %esi,%esi
801063e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801063f0:	83 ec 0c             	sub    $0xc,%esp
801063f3:	68 c0 6b 11 80       	push   $0x80116bc0
801063f8:	e8 13 ee ff ff       	call   80105210 <release>
  return 0;
801063fd:	83 c4 10             	add    $0x10,%esp
80106400:	31 c0                	xor    %eax,%eax
}
80106402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106405:	c9                   	leave  
80106406:	c3                   	ret    
    return -1;
80106407:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010640c:	eb f4                	jmp    80106402 <sys_sleep+0xa2>
8010640e:	66 90                	xchg   %ax,%ax

80106410 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	53                   	push   %ebx
80106414:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106417:	68 c0 6b 11 80       	push   $0x80116bc0
8010641c:	e8 2f ed ff ff       	call   80105150 <acquire>
  xticks = ticks;
80106421:	8b 1d 00 74 11 80    	mov    0x80117400,%ebx
  release(&tickslock);
80106427:	c7 04 24 c0 6b 11 80 	movl   $0x80116bc0,(%esp)
8010642e:	e8 dd ed ff ff       	call   80105210 <release>
  return xticks;
}
80106433:	89 d8                	mov    %ebx,%eax
80106435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106438:	c9                   	leave  
80106439:	c3                   	ret    
8010643a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106440 <sys_getlev>:


int
sys_getlev(void)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
	return getlev();
}
80106443:	5d                   	pop    %ebp
	return getlev();
80106444:	e9 d7 d7 ff ff       	jmp    80103c20 <getlev>
80106449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106450 <sys_yield>:

int
sys_yield(void)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
	return yield();
}
80106453:	5d                   	pop    %ebp
	return yield();
80106454:	e9 a7 df ff ff       	jmp    80104400 <yield>
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106460 <sys_set_cpu_share>:

int
sys_set_cpu_share(void)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	83 ec 20             	sub    $0x20,%esp
	int cpu_share;
	if (argint(0, &cpu_share) < 0)
80106466:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106469:	50                   	push   %eax
8010646a:	6a 00                	push   $0x0
8010646c:	e8 ef f0 ff ff       	call   80105560 <argint>
80106471:	83 c4 10             	add    $0x10,%esp
80106474:	85 c0                	test   %eax,%eax
80106476:	78 18                	js     80106490 <sys_set_cpu_share+0x30>
		return -1;
	return set_cpu_share(cpu_share);
80106478:	83 ec 0c             	sub    $0xc,%esp
8010647b:	ff 75 f4             	pushl  -0xc(%ebp)
8010647e:	e8 cd d7 ff ff       	call   80103c50 <set_cpu_share>
80106483:	83 c4 10             	add    $0x10,%esp
}
80106486:	c9                   	leave  
80106487:	c3                   	ret    
80106488:	90                   	nop
80106489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return -1;
80106490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106495:	c9                   	leave  
80106496:	c3                   	ret    
80106497:	89 f6                	mov    %esi,%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064a0 <sys_thread_create>:

int
sys_thread_create(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	83 ec 20             	sub    $0x20,%esp
    int thread, routine, arg;

    if(argint(0, &thread) < 0)
801064a6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064a9:	50                   	push   %eax
801064aa:	6a 00                	push   $0x0
801064ac:	e8 af f0 ff ff       	call   80105560 <argint>
801064b1:	83 c4 10             	add    $0x10,%esp
801064b4:	85 c0                	test   %eax,%eax
801064b6:	78 48                	js     80106500 <sys_thread_create+0x60>
        return -1;

    if(argint(1, &routine) < 0)
801064b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064bb:	83 ec 08             	sub    $0x8,%esp
801064be:	50                   	push   %eax
801064bf:	6a 01                	push   $0x1
801064c1:	e8 9a f0 ff ff       	call   80105560 <argint>
801064c6:	83 c4 10             	add    $0x10,%esp
801064c9:	85 c0                	test   %eax,%eax
801064cb:	78 33                	js     80106500 <sys_thread_create+0x60>
        return -1;

    if(argint(2, &arg) < 0)
801064cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064d0:	83 ec 08             	sub    $0x8,%esp
801064d3:	50                   	push   %eax
801064d4:	6a 02                	push   $0x2
801064d6:	e8 85 f0 ff ff       	call   80105560 <argint>
801064db:	83 c4 10             	add    $0x10,%esp
801064de:	85 c0                	test   %eax,%eax
801064e0:	78 1e                	js     80106500 <sys_thread_create+0x60>
        return -1;

    return thread_create((thread_t*)thread, (void*)routine, (void*)arg);
801064e2:	83 ec 04             	sub    $0x4,%esp
801064e5:	ff 75 f4             	pushl  -0xc(%ebp)
801064e8:	ff 75 f0             	pushl  -0x10(%ebp)
801064eb:	ff 75 ec             	pushl  -0x14(%ebp)
801064ee:	e8 6d e6 ff ff       	call   80104b60 <thread_create>
801064f3:	83 c4 10             	add    $0x10,%esp
}
801064f6:	c9                   	leave  
801064f7:	c3                   	ret    
801064f8:	90                   	nop
801064f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106505:	c9                   	leave  
80106506:	c3                   	ret    
80106507:	89 f6                	mov    %esi,%esi
80106509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106510 <sys_thread_exit>:

int
sys_thread_exit(void)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	83 ec 20             	sub    $0x20,%esp
    int retval;

    if(argint(0, &retval) < 0)
80106516:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106519:	50                   	push   %eax
8010651a:	6a 00                	push   $0x0
8010651c:	e8 3f f0 ff ff       	call   80105560 <argint>
80106521:	83 c4 10             	add    $0x10,%esp
80106524:	85 c0                	test   %eax,%eax
80106526:	78 18                	js     80106540 <sys_thread_exit+0x30>
        return -1;

    thread_exit((void*)retval);
80106528:	83 ec 0c             	sub    $0xc,%esp
8010652b:	ff 75 f4             	pushl  -0xc(%ebp)
8010652e:	e8 bd e7 ff ff       	call   80104cf0 <thread_exit>
    return 0;
80106533:	83 c4 10             	add    $0x10,%esp
80106536:	31 c0                	xor    %eax,%eax
}
80106538:	c9                   	leave  
80106539:	c3                   	ret    
8010653a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80106540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106545:	c9                   	leave  
80106546:	c3                   	ret    
80106547:	89 f6                	mov    %esi,%esi
80106549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106550 <sys_thread_join>:

int
sys_thread_join(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 20             	sub    $0x20,%esp
    int thread, retval;

    if(argint(0, &thread) < 0)
80106556:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106559:	50                   	push   %eax
8010655a:	6a 00                	push   $0x0
8010655c:	e8 ff ef ff ff       	call   80105560 <argint>
80106561:	83 c4 10             	add    $0x10,%esp
80106564:	85 c0                	test   %eax,%eax
80106566:	78 28                	js     80106590 <sys_thread_join+0x40>
        return -1;

    if(argint(1, &retval) < 0)
80106568:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010656b:	83 ec 08             	sub    $0x8,%esp
8010656e:	50                   	push   %eax
8010656f:	6a 01                	push   $0x1
80106571:	e8 ea ef ff ff       	call   80105560 <argint>
80106576:	83 c4 10             	add    $0x10,%esp
80106579:	85 c0                	test   %eax,%eax
8010657b:	78 13                	js     80106590 <sys_thread_join+0x40>
        return -1;

    return thread_join((thread_t)thread, (void**)retval);
8010657d:	83 ec 08             	sub    $0x8,%esp
80106580:	ff 75 f4             	pushl  -0xc(%ebp)
80106583:	ff 75 f0             	pushl  -0x10(%ebp)
80106586:	e8 05 e8 ff ff       	call   80104d90 <thread_join>
8010658b:	83 c4 10             	add    $0x10,%esp
}
8010658e:	c9                   	leave  
8010658f:	c3                   	ret    
        return -1;
80106590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106595:	c9                   	leave  
80106596:	c3                   	ret    

80106597 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106597:	1e                   	push   %ds
  pushl %es
80106598:	06                   	push   %es
  pushl %fs
80106599:	0f a0                	push   %fs
  pushl %gs
8010659b:	0f a8                	push   %gs
  pushal
8010659d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010659e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801065a2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801065a4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801065a6:	54                   	push   %esp
  call trap
801065a7:	e8 c4 00 00 00       	call   80106670 <trap>
  addl $4, %esp
801065ac:	83 c4 04             	add    $0x4,%esp

801065af <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801065af:	61                   	popa   
  popl %gs
801065b0:	0f a9                	pop    %gs
  popl %fs
801065b2:	0f a1                	pop    %fs
  popl %es
801065b4:	07                   	pop    %es
  popl %ds
801065b5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801065b6:	83 c4 08             	add    $0x8,%esp
  iret
801065b9:	cf                   	iret   
801065ba:	66 90                	xchg   %ax,%ax
801065bc:	66 90                	xchg   %ax,%ax
801065be:	66 90                	xchg   %ax,%ax

801065c0 <tvinit>:
extern const uint TIME_QUANTUM[];		// in proc.c: array of time quantum
extern uint boost_tick;							// in proc.c: logical tick counter for priority boost

void
tvinit(void)
{
801065c0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801065c1:	31 c0                	xor    %eax,%eax
{
801065c3:	89 e5                	mov    %esp,%ebp
801065c5:	83 ec 08             	sub    $0x8,%esp
801065c8:	90                   	nop
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801065d0:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
801065d7:	c7 04 c5 02 6c 11 80 	movl   $0x8e000008,-0x7fee93fe(,%eax,8)
801065de:	08 00 00 8e 
801065e2:	66 89 14 c5 00 6c 11 	mov    %dx,-0x7fee9400(,%eax,8)
801065e9:	80 
801065ea:	c1 ea 10             	shr    $0x10,%edx
801065ed:	66 89 14 c5 06 6c 11 	mov    %dx,-0x7fee93fa(,%eax,8)
801065f4:	80 
  for(i = 0; i < 256; i++)
801065f5:	83 c0 01             	add    $0x1,%eax
801065f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801065fd:	75 d1                	jne    801065d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065ff:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

  initlock(&tickslock, "time");
80106604:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106607:	c7 05 02 6e 11 80 08 	movl   $0xef000008,0x80116e02
8010660e:	00 00 ef 
  initlock(&tickslock, "time");
80106611:	68 51 87 10 80       	push   $0x80108751
80106616:	68 c0 6b 11 80       	push   $0x80116bc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010661b:	66 a3 00 6e 11 80    	mov    %ax,0x80116e00
80106621:	c1 e8 10             	shr    $0x10,%eax
80106624:	66 a3 06 6e 11 80    	mov    %ax,0x80116e06
  initlock(&tickslock, "time");
8010662a:	e8 e1 e9 ff ff       	call   80105010 <initlock>
}
8010662f:	83 c4 10             	add    $0x10,%esp
80106632:	c9                   	leave  
80106633:	c3                   	ret    
80106634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010663a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106640 <idtinit>:

void
idtinit(void)
{
80106640:	55                   	push   %ebp
  pd[0] = size-1;
80106641:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106646:	89 e5                	mov    %esp,%ebp
80106648:	83 ec 10             	sub    $0x10,%esp
8010664b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010664f:	b8 00 6c 11 80       	mov    $0x80116c00,%eax
80106654:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106658:	c1 e8 10             	shr    $0x10,%eax
8010665b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010665f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106662:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106665:	c9                   	leave  
80106666:	c3                   	ret    
80106667:	89 f6                	mov    %esi,%esi
80106669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106670 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	56                   	push   %esi
80106675:	53                   	push   %ebx
80106676:	83 ec 1c             	sub    $0x1c,%esp
80106679:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010667c:	8b 47 30             	mov    0x30(%edi),%eax
8010667f:	83 f8 40             	cmp    $0x40,%eax
80106682:	0f 84 f0 00 00 00    	je     80106778 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106688:	83 e8 20             	sub    $0x20,%eax
8010668b:	83 f8 1f             	cmp    $0x1f,%eax
8010668e:	77 10                	ja     801066a0 <trap+0x30>
80106690:	ff 24 85 f8 87 10 80 	jmp    *-0x7fef7808(,%eax,4)
80106697:	89 f6                	mov    %esi,%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801066a0:	e8 cb d6 ff ff       	call   80103d70 <myproc>
801066a5:	85 c0                	test   %eax,%eax
801066a7:	8b 5f 38             	mov    0x38(%edi),%ebx
801066aa:	0f 84 aa 02 00 00    	je     8010695a <trap+0x2ea>
801066b0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801066b4:	0f 84 a0 02 00 00    	je     8010695a <trap+0x2ea>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801066ba:	0f 20 d1             	mov    %cr2,%ecx
801066bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066c0:	e8 3b d5 ff ff       	call   80103c00 <cpuid>
801066c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801066c8:	8b 47 34             	mov    0x34(%edi),%eax
801066cb:	8b 77 30             	mov    0x30(%edi),%esi
801066ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801066d1:	e8 9a d6 ff ff       	call   80103d70 <myproc>
801066d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801066d9:	e8 92 d6 ff ff       	call   80103d70 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801066e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066e4:	51                   	push   %ecx
801066e5:	53                   	push   %ebx
801066e6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801066e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801066ed:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801066ee:	83 c2 70             	add    $0x70,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066f1:	52                   	push   %edx
801066f2:	ff 70 14             	pushl  0x14(%eax)
801066f5:	68 b4 87 10 80       	push   $0x801087b4
801066fa:	e8 61 9f ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801066ff:	83 c4 20             	add    $0x20,%esp
80106702:	e8 69 d6 ff ff       	call   80103d70 <myproc>
80106707:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010670e:	e8 5d d6 ff ff       	call   80103d70 <myproc>
80106713:	85 c0                	test   %eax,%eax
80106715:	74 1d                	je     80106734 <trap+0xc4>
80106717:	e8 54 d6 ff ff       	call   80103d70 <myproc>
8010671c:	8b 48 28             	mov    0x28(%eax),%ecx
8010671f:	85 c9                	test   %ecx,%ecx
80106721:	74 11                	je     80106734 <trap+0xc4>
80106723:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106727:	83 e0 03             	and    $0x3,%eax
8010672a:	66 83 f8 03          	cmp    $0x3,%ax
8010672e:	0f 84 9c 01 00 00    	je     801068d0 <trap+0x260>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106734:	e8 37 d6 ff ff       	call   80103d70 <myproc>
80106739:	85 c0                	test   %eax,%eax
8010673b:	74 0b                	je     80106748 <trap+0xd8>
8010673d:	e8 2e d6 ff ff       	call   80103d70 <myproc>
80106742:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80106746:	74 68                	je     801067b0 <trap+0x140>
			} 
		}
	}

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106748:	e8 23 d6 ff ff       	call   80103d70 <myproc>
8010674d:	85 c0                	test   %eax,%eax
8010674f:	74 19                	je     8010676a <trap+0xfa>
80106751:	e8 1a d6 ff ff       	call   80103d70 <myproc>
80106756:	8b 40 28             	mov    0x28(%eax),%eax
80106759:	85 c0                	test   %eax,%eax
8010675b:	74 0d                	je     8010676a <trap+0xfa>
8010675d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106761:	83 e0 03             	and    $0x3,%eax
80106764:	66 83 f8 03          	cmp    $0x3,%ax
80106768:	74 37                	je     801067a1 <trap+0x131>
    exit();
}
8010676a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010676d:	5b                   	pop    %ebx
8010676e:	5e                   	pop    %esi
8010676f:	5f                   	pop    %edi
80106770:	5d                   	pop    %ebp
80106771:	c3                   	ret    
80106772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106778:	e8 f3 d5 ff ff       	call   80103d70 <myproc>
8010677d:	8b 70 28             	mov    0x28(%eax),%esi
80106780:	85 f6                	test   %esi,%esi
80106782:	0f 85 38 01 00 00    	jne    801068c0 <trap+0x250>
    myproc()->tf = tf;
80106788:	e8 e3 d5 ff ff       	call   80103d70 <myproc>
8010678d:	89 78 1c             	mov    %edi,0x1c(%eax)
    syscall();
80106790:	e8 bb ee ff ff       	call   80105650 <syscall>
    if(myproc()->killed)
80106795:	e8 d6 d5 ff ff       	call   80103d70 <myproc>
8010679a:	8b 58 28             	mov    0x28(%eax),%ebx
8010679d:	85 db                	test   %ebx,%ebx
8010679f:	74 c9                	je     8010676a <trap+0xfa>
}
801067a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067a4:	5b                   	pop    %ebx
801067a5:	5e                   	pop    %esi
801067a6:	5f                   	pop    %edi
801067a7:	5d                   	pop    %ebp
      exit();
801067a8:	e9 b3 dd ff ff       	jmp    80104560 <exit>
801067ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801067b0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801067b4:	75 92                	jne    80106748 <trap+0xd8>
		boost_tick++;
801067b6:	83 05 c0 b5 10 80 01 	addl   $0x1,0x8010b5c0
		myproc()->tick_cnt++;
801067bd:	e8 ae d5 ff ff       	call   80103d70 <myproc>
801067c2:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
		if (boost_tick >= BOOST_LIMIT) {
801067c9:	83 3d c0 b5 10 80 63 	cmpl   $0x63,0x8010b5c0
801067d0:	0f 87 7a 01 00 00    	ja     80106950 <trap+0x2e0>
		if (myproc()->is_stride) {
801067d6:	e8 95 d5 ff ff       	call   80103d70 <myproc>
801067db:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
801067e1:	85 d2                	test   %edx,%edx
801067e3:	0f 84 2f 01 00 00    	je     80106918 <trap+0x2a8>
			myproc()->pass_value += myproc()->stride;
801067e9:	e8 82 d5 ff ff       	call   80103d70 <myproc>
801067ee:	8b 98 8c 00 00 00    	mov    0x8c(%eax),%ebx
801067f4:	e8 77 d5 ff ff       	call   80103d70 <myproc>
801067f9:	01 98 90 00 00 00    	add    %ebx,0x90(%eax)
			tick_yield();
801067ff:	e8 8c de ff ff       	call   80104690 <tick_yield>
80106804:	e9 3f ff ff ff       	jmp    80106748 <trap+0xd8>
80106809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106810:	e8 eb d3 ff ff       	call   80103c00 <cpuid>
80106815:	85 c0                	test   %eax,%eax
80106817:	0f 84 c3 00 00 00    	je     801068e0 <trap+0x270>
    lapiceoi();
8010681d:	e8 2e bf ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106822:	e8 49 d5 ff ff       	call   80103d70 <myproc>
80106827:	85 c0                	test   %eax,%eax
80106829:	0f 85 e8 fe ff ff    	jne    80106717 <trap+0xa7>
8010682f:	e9 00 ff ff ff       	jmp    80106734 <trap+0xc4>
80106834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106838:	e8 d3 bd ff ff       	call   80102610 <kbdintr>
    lapiceoi();
8010683d:	e8 0e bf ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106842:	e8 29 d5 ff ff       	call   80103d70 <myproc>
80106847:	85 c0                	test   %eax,%eax
80106849:	0f 85 c8 fe ff ff    	jne    80106717 <trap+0xa7>
8010684f:	e9 e0 fe ff ff       	jmp    80106734 <trap+0xc4>
80106854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106858:	e8 a3 02 00 00       	call   80106b00 <uartintr>
    lapiceoi();
8010685d:	e8 ee be ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106862:	e8 09 d5 ff ff       	call   80103d70 <myproc>
80106867:	85 c0                	test   %eax,%eax
80106869:	0f 85 a8 fe ff ff    	jne    80106717 <trap+0xa7>
8010686f:	e9 c0 fe ff ff       	jmp    80106734 <trap+0xc4>
80106874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106878:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010687c:	8b 77 38             	mov    0x38(%edi),%esi
8010687f:	e8 7c d3 ff ff       	call   80103c00 <cpuid>
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
80106886:	50                   	push   %eax
80106887:	68 5c 87 10 80       	push   $0x8010875c
8010688c:	e8 cf 9d ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106891:	e8 ba be ff ff       	call   80102750 <lapiceoi>
    break;
80106896:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106899:	e8 d2 d4 ff ff       	call   80103d70 <myproc>
8010689e:	85 c0                	test   %eax,%eax
801068a0:	0f 85 71 fe ff ff    	jne    80106717 <trap+0xa7>
801068a6:	e9 89 fe ff ff       	jmp    80106734 <trap+0xc4>
801068ab:	90                   	nop
801068ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801068b0:	e8 cb b7 ff ff       	call   80102080 <ideintr>
801068b5:	e9 63 ff ff ff       	jmp    8010681d <trap+0x1ad>
801068ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801068c0:	e8 9b dc ff ff       	call   80104560 <exit>
801068c5:	e9 be fe ff ff       	jmp    80106788 <trap+0x118>
801068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801068d0:	e8 8b dc ff ff       	call   80104560 <exit>
801068d5:	e9 5a fe ff ff       	jmp    80106734 <trap+0xc4>
801068da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801068e0:	83 ec 0c             	sub    $0xc,%esp
801068e3:	68 c0 6b 11 80       	push   $0x80116bc0
801068e8:	e8 63 e8 ff ff       	call   80105150 <acquire>
      wakeup(&ticks);
801068ed:	c7 04 24 00 74 11 80 	movl   $0x80117400,(%esp)
      ticks++;
801068f4:	83 05 00 74 11 80 01 	addl   $0x1,0x80117400
      wakeup(&ticks);
801068fb:	e8 80 e0 ff ff       	call   80104980 <wakeup>
      release(&tickslock);
80106900:	c7 04 24 c0 6b 11 80 	movl   $0x80116bc0,(%esp)
80106907:	e8 04 e9 ff ff       	call   80105210 <release>
8010690c:	83 c4 10             	add    $0x10,%esp
8010690f:	e9 09 ff ff ff       	jmp    8010681d <trap+0x1ad>
80106914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			mlfq_pass_inc();
80106918:	e8 b3 cf ff ff       	call   801038d0 <mlfq_pass_inc>
			if (myproc()->tick_cnt % TIME_QUANTUM[myproc()->lev] == 0) {
8010691d:	e8 4e d4 ff ff       	call   80103d70 <myproc>
80106922:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
80106928:	e8 43 d4 ff ff       	call   80103d70 <myproc>
8010692d:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80106933:	31 d2                	xor    %edx,%edx
80106935:	89 d8                	mov    %ebx,%eax
80106937:	f7 34 8d 0c 86 10 80 	divl   -0x7fef79f4(,%ecx,4)
8010693e:	85 d2                	test   %edx,%edx
80106940:	0f 85 02 fe ff ff    	jne    80106748 <trap+0xd8>
				tick_yield();
80106946:	e8 45 dd ff ff       	call   80104690 <tick_yield>
8010694b:	e9 f8 fd ff ff       	jmp    80106748 <trap+0xd8>
			priority_boost();
80106950:	e8 8b cf ff ff       	call   801038e0 <priority_boost>
80106955:	e9 7c fe ff ff       	jmp    801067d6 <trap+0x166>
8010695a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010695d:	e8 9e d2 ff ff       	call   80103c00 <cpuid>
80106962:	83 ec 0c             	sub    $0xc,%esp
80106965:	56                   	push   %esi
80106966:	53                   	push   %ebx
80106967:	50                   	push   %eax
80106968:	ff 77 30             	pushl  0x30(%edi)
8010696b:	68 80 87 10 80       	push   $0x80108780
80106970:	e8 eb 9c ff ff       	call   80100660 <cprintf>
      panic("trap");
80106975:	83 c4 14             	add    $0x14,%esp
80106978:	68 56 87 10 80       	push   $0x80108756
8010697d:	e8 0e 9a ff ff       	call   80100390 <panic>
80106982:	66 90                	xchg   %ax,%ax
80106984:	66 90                	xchg   %ax,%ax
80106986:	66 90                	xchg   %ax,%ax
80106988:	66 90                	xchg   %ax,%ax
8010698a:	66 90                	xchg   %ax,%ax
8010698c:	66 90                	xchg   %ax,%ax
8010698e:	66 90                	xchg   %ax,%ax

80106990 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106990:	a1 c8 b5 10 80       	mov    0x8010b5c8,%eax
{
80106995:	55                   	push   %ebp
80106996:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106998:	85 c0                	test   %eax,%eax
8010699a:	74 1c                	je     801069b8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010699c:	ba fd 03 00 00       	mov    $0x3fd,%edx
801069a1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801069a2:	a8 01                	test   $0x1,%al
801069a4:	74 12                	je     801069b8 <uartgetc+0x28>
801069a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069ab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801069ac:	0f b6 c0             	movzbl %al,%eax
}
801069af:	5d                   	pop    %ebp
801069b0:	c3                   	ret    
801069b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801069b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069bd:	5d                   	pop    %ebp
801069be:	c3                   	ret    
801069bf:	90                   	nop

801069c0 <uartputc.part.0>:
uartputc(int c)
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	89 c7                	mov    %eax,%edi
801069c8:	bb 80 00 00 00       	mov    $0x80,%ebx
801069cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801069d2:	83 ec 0c             	sub    $0xc,%esp
801069d5:	eb 1b                	jmp    801069f2 <uartputc.part.0+0x32>
801069d7:	89 f6                	mov    %esi,%esi
801069d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801069e0:	83 ec 0c             	sub    $0xc,%esp
801069e3:	6a 0a                	push   $0xa
801069e5:	e8 86 bd ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801069ea:	83 c4 10             	add    $0x10,%esp
801069ed:	83 eb 01             	sub    $0x1,%ebx
801069f0:	74 07                	je     801069f9 <uartputc.part.0+0x39>
801069f2:	89 f2                	mov    %esi,%edx
801069f4:	ec                   	in     (%dx),%al
801069f5:	a8 20                	test   $0x20,%al
801069f7:	74 e7                	je     801069e0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069fe:	89 f8                	mov    %edi,%eax
80106a00:	ee                   	out    %al,(%dx)
}
80106a01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a04:	5b                   	pop    %ebx
80106a05:	5e                   	pop    %esi
80106a06:	5f                   	pop    %edi
80106a07:	5d                   	pop    %ebp
80106a08:	c3                   	ret    
80106a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a10 <uartinit>:
{
80106a10:	55                   	push   %ebp
80106a11:	31 c9                	xor    %ecx,%ecx
80106a13:	89 c8                	mov    %ecx,%eax
80106a15:	89 e5                	mov    %esp,%ebp
80106a17:	57                   	push   %edi
80106a18:	56                   	push   %esi
80106a19:	53                   	push   %ebx
80106a1a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106a1f:	89 da                	mov    %ebx,%edx
80106a21:	83 ec 0c             	sub    $0xc,%esp
80106a24:	ee                   	out    %al,(%dx)
80106a25:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106a2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106a2f:	89 fa                	mov    %edi,%edx
80106a31:	ee                   	out    %al,(%dx)
80106a32:	b8 0c 00 00 00       	mov    $0xc,%eax
80106a37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a3c:	ee                   	out    %al,(%dx)
80106a3d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106a42:	89 c8                	mov    %ecx,%eax
80106a44:	89 f2                	mov    %esi,%edx
80106a46:	ee                   	out    %al,(%dx)
80106a47:	b8 03 00 00 00       	mov    $0x3,%eax
80106a4c:	89 fa                	mov    %edi,%edx
80106a4e:	ee                   	out    %al,(%dx)
80106a4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106a54:	89 c8                	mov    %ecx,%eax
80106a56:	ee                   	out    %al,(%dx)
80106a57:	b8 01 00 00 00       	mov    $0x1,%eax
80106a5c:	89 f2                	mov    %esi,%edx
80106a5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a64:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106a65:	3c ff                	cmp    $0xff,%al
80106a67:	74 5a                	je     80106ac3 <uartinit+0xb3>
  uart = 1;
80106a69:	c7 05 c8 b5 10 80 01 	movl   $0x1,0x8010b5c8
80106a70:	00 00 00 
80106a73:	89 da                	mov    %ebx,%edx
80106a75:	ec                   	in     (%dx),%al
80106a76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a7b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106a7c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106a7f:	bb 78 88 10 80       	mov    $0x80108878,%ebx
  ioapicenable(IRQ_COM1, 0);
80106a84:	6a 00                	push   $0x0
80106a86:	6a 04                	push   $0x4
80106a88:	e8 43 b8 ff ff       	call   801022d0 <ioapicenable>
80106a8d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106a90:	b8 78 00 00 00       	mov    $0x78,%eax
80106a95:	eb 13                	jmp    80106aaa <uartinit+0x9a>
80106a97:	89 f6                	mov    %esi,%esi
80106a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106aa0:	83 c3 01             	add    $0x1,%ebx
80106aa3:	0f be 03             	movsbl (%ebx),%eax
80106aa6:	84 c0                	test   %al,%al
80106aa8:	74 19                	je     80106ac3 <uartinit+0xb3>
  if(!uart)
80106aaa:	8b 15 c8 b5 10 80    	mov    0x8010b5c8,%edx
80106ab0:	85 d2                	test   %edx,%edx
80106ab2:	74 ec                	je     80106aa0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106ab4:	83 c3 01             	add    $0x1,%ebx
80106ab7:	e8 04 ff ff ff       	call   801069c0 <uartputc.part.0>
80106abc:	0f be 03             	movsbl (%ebx),%eax
80106abf:	84 c0                	test   %al,%al
80106ac1:	75 e7                	jne    80106aaa <uartinit+0x9a>
}
80106ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ac6:	5b                   	pop    %ebx
80106ac7:	5e                   	pop    %esi
80106ac8:	5f                   	pop    %edi
80106ac9:	5d                   	pop    %ebp
80106aca:	c3                   	ret    
80106acb:	90                   	nop
80106acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ad0 <uartputc>:
  if(!uart)
80106ad0:	8b 15 c8 b5 10 80    	mov    0x8010b5c8,%edx
{
80106ad6:	55                   	push   %ebp
80106ad7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106ad9:	85 d2                	test   %edx,%edx
{
80106adb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106ade:	74 10                	je     80106af0 <uartputc+0x20>
}
80106ae0:	5d                   	pop    %ebp
80106ae1:	e9 da fe ff ff       	jmp    801069c0 <uartputc.part.0>
80106ae6:	8d 76 00             	lea    0x0(%esi),%esi
80106ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106af0:	5d                   	pop    %ebp
80106af1:	c3                   	ret    
80106af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b00 <uartintr>:

void
uartintr(void)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106b06:	68 90 69 10 80       	push   $0x80106990
80106b0b:	e8 00 9d ff ff       	call   80100810 <consoleintr>
}
80106b10:	83 c4 10             	add    $0x10,%esp
80106b13:	c9                   	leave  
80106b14:	c3                   	ret    

80106b15 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106b15:	6a 00                	push   $0x0
  pushl $0
80106b17:	6a 00                	push   $0x0
  jmp alltraps
80106b19:	e9 79 fa ff ff       	jmp    80106597 <alltraps>

80106b1e <vector1>:
.globl vector1
vector1:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $1
80106b20:	6a 01                	push   $0x1
  jmp alltraps
80106b22:	e9 70 fa ff ff       	jmp    80106597 <alltraps>

80106b27 <vector2>:
.globl vector2
vector2:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $2
80106b29:	6a 02                	push   $0x2
  jmp alltraps
80106b2b:	e9 67 fa ff ff       	jmp    80106597 <alltraps>

80106b30 <vector3>:
.globl vector3
vector3:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $3
80106b32:	6a 03                	push   $0x3
  jmp alltraps
80106b34:	e9 5e fa ff ff       	jmp    80106597 <alltraps>

80106b39 <vector4>:
.globl vector4
vector4:
  pushl $0
80106b39:	6a 00                	push   $0x0
  pushl $4
80106b3b:	6a 04                	push   $0x4
  jmp alltraps
80106b3d:	e9 55 fa ff ff       	jmp    80106597 <alltraps>

80106b42 <vector5>:
.globl vector5
vector5:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $5
80106b44:	6a 05                	push   $0x5
  jmp alltraps
80106b46:	e9 4c fa ff ff       	jmp    80106597 <alltraps>

80106b4b <vector6>:
.globl vector6
vector6:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $6
80106b4d:	6a 06                	push   $0x6
  jmp alltraps
80106b4f:	e9 43 fa ff ff       	jmp    80106597 <alltraps>

80106b54 <vector7>:
.globl vector7
vector7:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $7
80106b56:	6a 07                	push   $0x7
  jmp alltraps
80106b58:	e9 3a fa ff ff       	jmp    80106597 <alltraps>

80106b5d <vector8>:
.globl vector8
vector8:
  pushl $8
80106b5d:	6a 08                	push   $0x8
  jmp alltraps
80106b5f:	e9 33 fa ff ff       	jmp    80106597 <alltraps>

80106b64 <vector9>:
.globl vector9
vector9:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $9
80106b66:	6a 09                	push   $0x9
  jmp alltraps
80106b68:	e9 2a fa ff ff       	jmp    80106597 <alltraps>

80106b6d <vector10>:
.globl vector10
vector10:
  pushl $10
80106b6d:	6a 0a                	push   $0xa
  jmp alltraps
80106b6f:	e9 23 fa ff ff       	jmp    80106597 <alltraps>

80106b74 <vector11>:
.globl vector11
vector11:
  pushl $11
80106b74:	6a 0b                	push   $0xb
  jmp alltraps
80106b76:	e9 1c fa ff ff       	jmp    80106597 <alltraps>

80106b7b <vector12>:
.globl vector12
vector12:
  pushl $12
80106b7b:	6a 0c                	push   $0xc
  jmp alltraps
80106b7d:	e9 15 fa ff ff       	jmp    80106597 <alltraps>

80106b82 <vector13>:
.globl vector13
vector13:
  pushl $13
80106b82:	6a 0d                	push   $0xd
  jmp alltraps
80106b84:	e9 0e fa ff ff       	jmp    80106597 <alltraps>

80106b89 <vector14>:
.globl vector14
vector14:
  pushl $14
80106b89:	6a 0e                	push   $0xe
  jmp alltraps
80106b8b:	e9 07 fa ff ff       	jmp    80106597 <alltraps>

80106b90 <vector15>:
.globl vector15
vector15:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $15
80106b92:	6a 0f                	push   $0xf
  jmp alltraps
80106b94:	e9 fe f9 ff ff       	jmp    80106597 <alltraps>

80106b99 <vector16>:
.globl vector16
vector16:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $16
80106b9b:	6a 10                	push   $0x10
  jmp alltraps
80106b9d:	e9 f5 f9 ff ff       	jmp    80106597 <alltraps>

80106ba2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ba2:	6a 11                	push   $0x11
  jmp alltraps
80106ba4:	e9 ee f9 ff ff       	jmp    80106597 <alltraps>

80106ba9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106ba9:	6a 00                	push   $0x0
  pushl $18
80106bab:	6a 12                	push   $0x12
  jmp alltraps
80106bad:	e9 e5 f9 ff ff       	jmp    80106597 <alltraps>

80106bb2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106bb2:	6a 00                	push   $0x0
  pushl $19
80106bb4:	6a 13                	push   $0x13
  jmp alltraps
80106bb6:	e9 dc f9 ff ff       	jmp    80106597 <alltraps>

80106bbb <vector20>:
.globl vector20
vector20:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $20
80106bbd:	6a 14                	push   $0x14
  jmp alltraps
80106bbf:	e9 d3 f9 ff ff       	jmp    80106597 <alltraps>

80106bc4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106bc4:	6a 00                	push   $0x0
  pushl $21
80106bc6:	6a 15                	push   $0x15
  jmp alltraps
80106bc8:	e9 ca f9 ff ff       	jmp    80106597 <alltraps>

80106bcd <vector22>:
.globl vector22
vector22:
  pushl $0
80106bcd:	6a 00                	push   $0x0
  pushl $22
80106bcf:	6a 16                	push   $0x16
  jmp alltraps
80106bd1:	e9 c1 f9 ff ff       	jmp    80106597 <alltraps>

80106bd6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106bd6:	6a 00                	push   $0x0
  pushl $23
80106bd8:	6a 17                	push   $0x17
  jmp alltraps
80106bda:	e9 b8 f9 ff ff       	jmp    80106597 <alltraps>

80106bdf <vector24>:
.globl vector24
vector24:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $24
80106be1:	6a 18                	push   $0x18
  jmp alltraps
80106be3:	e9 af f9 ff ff       	jmp    80106597 <alltraps>

80106be8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106be8:	6a 00                	push   $0x0
  pushl $25
80106bea:	6a 19                	push   $0x19
  jmp alltraps
80106bec:	e9 a6 f9 ff ff       	jmp    80106597 <alltraps>

80106bf1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106bf1:	6a 00                	push   $0x0
  pushl $26
80106bf3:	6a 1a                	push   $0x1a
  jmp alltraps
80106bf5:	e9 9d f9 ff ff       	jmp    80106597 <alltraps>

80106bfa <vector27>:
.globl vector27
vector27:
  pushl $0
80106bfa:	6a 00                	push   $0x0
  pushl $27
80106bfc:	6a 1b                	push   $0x1b
  jmp alltraps
80106bfe:	e9 94 f9 ff ff       	jmp    80106597 <alltraps>

80106c03 <vector28>:
.globl vector28
vector28:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $28
80106c05:	6a 1c                	push   $0x1c
  jmp alltraps
80106c07:	e9 8b f9 ff ff       	jmp    80106597 <alltraps>

80106c0c <vector29>:
.globl vector29
vector29:
  pushl $0
80106c0c:	6a 00                	push   $0x0
  pushl $29
80106c0e:	6a 1d                	push   $0x1d
  jmp alltraps
80106c10:	e9 82 f9 ff ff       	jmp    80106597 <alltraps>

80106c15 <vector30>:
.globl vector30
vector30:
  pushl $0
80106c15:	6a 00                	push   $0x0
  pushl $30
80106c17:	6a 1e                	push   $0x1e
  jmp alltraps
80106c19:	e9 79 f9 ff ff       	jmp    80106597 <alltraps>

80106c1e <vector31>:
.globl vector31
vector31:
  pushl $0
80106c1e:	6a 00                	push   $0x0
  pushl $31
80106c20:	6a 1f                	push   $0x1f
  jmp alltraps
80106c22:	e9 70 f9 ff ff       	jmp    80106597 <alltraps>

80106c27 <vector32>:
.globl vector32
vector32:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $32
80106c29:	6a 20                	push   $0x20
  jmp alltraps
80106c2b:	e9 67 f9 ff ff       	jmp    80106597 <alltraps>

80106c30 <vector33>:
.globl vector33
vector33:
  pushl $0
80106c30:	6a 00                	push   $0x0
  pushl $33
80106c32:	6a 21                	push   $0x21
  jmp alltraps
80106c34:	e9 5e f9 ff ff       	jmp    80106597 <alltraps>

80106c39 <vector34>:
.globl vector34
vector34:
  pushl $0
80106c39:	6a 00                	push   $0x0
  pushl $34
80106c3b:	6a 22                	push   $0x22
  jmp alltraps
80106c3d:	e9 55 f9 ff ff       	jmp    80106597 <alltraps>

80106c42 <vector35>:
.globl vector35
vector35:
  pushl $0
80106c42:	6a 00                	push   $0x0
  pushl $35
80106c44:	6a 23                	push   $0x23
  jmp alltraps
80106c46:	e9 4c f9 ff ff       	jmp    80106597 <alltraps>

80106c4b <vector36>:
.globl vector36
vector36:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $36
80106c4d:	6a 24                	push   $0x24
  jmp alltraps
80106c4f:	e9 43 f9 ff ff       	jmp    80106597 <alltraps>

80106c54 <vector37>:
.globl vector37
vector37:
  pushl $0
80106c54:	6a 00                	push   $0x0
  pushl $37
80106c56:	6a 25                	push   $0x25
  jmp alltraps
80106c58:	e9 3a f9 ff ff       	jmp    80106597 <alltraps>

80106c5d <vector38>:
.globl vector38
vector38:
  pushl $0
80106c5d:	6a 00                	push   $0x0
  pushl $38
80106c5f:	6a 26                	push   $0x26
  jmp alltraps
80106c61:	e9 31 f9 ff ff       	jmp    80106597 <alltraps>

80106c66 <vector39>:
.globl vector39
vector39:
  pushl $0
80106c66:	6a 00                	push   $0x0
  pushl $39
80106c68:	6a 27                	push   $0x27
  jmp alltraps
80106c6a:	e9 28 f9 ff ff       	jmp    80106597 <alltraps>

80106c6f <vector40>:
.globl vector40
vector40:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $40
80106c71:	6a 28                	push   $0x28
  jmp alltraps
80106c73:	e9 1f f9 ff ff       	jmp    80106597 <alltraps>

80106c78 <vector41>:
.globl vector41
vector41:
  pushl $0
80106c78:	6a 00                	push   $0x0
  pushl $41
80106c7a:	6a 29                	push   $0x29
  jmp alltraps
80106c7c:	e9 16 f9 ff ff       	jmp    80106597 <alltraps>

80106c81 <vector42>:
.globl vector42
vector42:
  pushl $0
80106c81:	6a 00                	push   $0x0
  pushl $42
80106c83:	6a 2a                	push   $0x2a
  jmp alltraps
80106c85:	e9 0d f9 ff ff       	jmp    80106597 <alltraps>

80106c8a <vector43>:
.globl vector43
vector43:
  pushl $0
80106c8a:	6a 00                	push   $0x0
  pushl $43
80106c8c:	6a 2b                	push   $0x2b
  jmp alltraps
80106c8e:	e9 04 f9 ff ff       	jmp    80106597 <alltraps>

80106c93 <vector44>:
.globl vector44
vector44:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $44
80106c95:	6a 2c                	push   $0x2c
  jmp alltraps
80106c97:	e9 fb f8 ff ff       	jmp    80106597 <alltraps>

80106c9c <vector45>:
.globl vector45
vector45:
  pushl $0
80106c9c:	6a 00                	push   $0x0
  pushl $45
80106c9e:	6a 2d                	push   $0x2d
  jmp alltraps
80106ca0:	e9 f2 f8 ff ff       	jmp    80106597 <alltraps>

80106ca5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ca5:	6a 00                	push   $0x0
  pushl $46
80106ca7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ca9:	e9 e9 f8 ff ff       	jmp    80106597 <alltraps>

80106cae <vector47>:
.globl vector47
vector47:
  pushl $0
80106cae:	6a 00                	push   $0x0
  pushl $47
80106cb0:	6a 2f                	push   $0x2f
  jmp alltraps
80106cb2:	e9 e0 f8 ff ff       	jmp    80106597 <alltraps>

80106cb7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $48
80106cb9:	6a 30                	push   $0x30
  jmp alltraps
80106cbb:	e9 d7 f8 ff ff       	jmp    80106597 <alltraps>

80106cc0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106cc0:	6a 00                	push   $0x0
  pushl $49
80106cc2:	6a 31                	push   $0x31
  jmp alltraps
80106cc4:	e9 ce f8 ff ff       	jmp    80106597 <alltraps>

80106cc9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106cc9:	6a 00                	push   $0x0
  pushl $50
80106ccb:	6a 32                	push   $0x32
  jmp alltraps
80106ccd:	e9 c5 f8 ff ff       	jmp    80106597 <alltraps>

80106cd2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $51
80106cd4:	6a 33                	push   $0x33
  jmp alltraps
80106cd6:	e9 bc f8 ff ff       	jmp    80106597 <alltraps>

80106cdb <vector52>:
.globl vector52
vector52:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $52
80106cdd:	6a 34                	push   $0x34
  jmp alltraps
80106cdf:	e9 b3 f8 ff ff       	jmp    80106597 <alltraps>

80106ce4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106ce4:	6a 00                	push   $0x0
  pushl $53
80106ce6:	6a 35                	push   $0x35
  jmp alltraps
80106ce8:	e9 aa f8 ff ff       	jmp    80106597 <alltraps>

80106ced <vector54>:
.globl vector54
vector54:
  pushl $0
80106ced:	6a 00                	push   $0x0
  pushl $54
80106cef:	6a 36                	push   $0x36
  jmp alltraps
80106cf1:	e9 a1 f8 ff ff       	jmp    80106597 <alltraps>

80106cf6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $55
80106cf8:	6a 37                	push   $0x37
  jmp alltraps
80106cfa:	e9 98 f8 ff ff       	jmp    80106597 <alltraps>

80106cff <vector56>:
.globl vector56
vector56:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $56
80106d01:	6a 38                	push   $0x38
  jmp alltraps
80106d03:	e9 8f f8 ff ff       	jmp    80106597 <alltraps>

80106d08 <vector57>:
.globl vector57
vector57:
  pushl $0
80106d08:	6a 00                	push   $0x0
  pushl $57
80106d0a:	6a 39                	push   $0x39
  jmp alltraps
80106d0c:	e9 86 f8 ff ff       	jmp    80106597 <alltraps>

80106d11 <vector58>:
.globl vector58
vector58:
  pushl $0
80106d11:	6a 00                	push   $0x0
  pushl $58
80106d13:	6a 3a                	push   $0x3a
  jmp alltraps
80106d15:	e9 7d f8 ff ff       	jmp    80106597 <alltraps>

80106d1a <vector59>:
.globl vector59
vector59:
  pushl $0
80106d1a:	6a 00                	push   $0x0
  pushl $59
80106d1c:	6a 3b                	push   $0x3b
  jmp alltraps
80106d1e:	e9 74 f8 ff ff       	jmp    80106597 <alltraps>

80106d23 <vector60>:
.globl vector60
vector60:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $60
80106d25:	6a 3c                	push   $0x3c
  jmp alltraps
80106d27:	e9 6b f8 ff ff       	jmp    80106597 <alltraps>

80106d2c <vector61>:
.globl vector61
vector61:
  pushl $0
80106d2c:	6a 00                	push   $0x0
  pushl $61
80106d2e:	6a 3d                	push   $0x3d
  jmp alltraps
80106d30:	e9 62 f8 ff ff       	jmp    80106597 <alltraps>

80106d35 <vector62>:
.globl vector62
vector62:
  pushl $0
80106d35:	6a 00                	push   $0x0
  pushl $62
80106d37:	6a 3e                	push   $0x3e
  jmp alltraps
80106d39:	e9 59 f8 ff ff       	jmp    80106597 <alltraps>

80106d3e <vector63>:
.globl vector63
vector63:
  pushl $0
80106d3e:	6a 00                	push   $0x0
  pushl $63
80106d40:	6a 3f                	push   $0x3f
  jmp alltraps
80106d42:	e9 50 f8 ff ff       	jmp    80106597 <alltraps>

80106d47 <vector64>:
.globl vector64
vector64:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $64
80106d49:	6a 40                	push   $0x40
  jmp alltraps
80106d4b:	e9 47 f8 ff ff       	jmp    80106597 <alltraps>

80106d50 <vector65>:
.globl vector65
vector65:
  pushl $0
80106d50:	6a 00                	push   $0x0
  pushl $65
80106d52:	6a 41                	push   $0x41
  jmp alltraps
80106d54:	e9 3e f8 ff ff       	jmp    80106597 <alltraps>

80106d59 <vector66>:
.globl vector66
vector66:
  pushl $0
80106d59:	6a 00                	push   $0x0
  pushl $66
80106d5b:	6a 42                	push   $0x42
  jmp alltraps
80106d5d:	e9 35 f8 ff ff       	jmp    80106597 <alltraps>

80106d62 <vector67>:
.globl vector67
vector67:
  pushl $0
80106d62:	6a 00                	push   $0x0
  pushl $67
80106d64:	6a 43                	push   $0x43
  jmp alltraps
80106d66:	e9 2c f8 ff ff       	jmp    80106597 <alltraps>

80106d6b <vector68>:
.globl vector68
vector68:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $68
80106d6d:	6a 44                	push   $0x44
  jmp alltraps
80106d6f:	e9 23 f8 ff ff       	jmp    80106597 <alltraps>

80106d74 <vector69>:
.globl vector69
vector69:
  pushl $0
80106d74:	6a 00                	push   $0x0
  pushl $69
80106d76:	6a 45                	push   $0x45
  jmp alltraps
80106d78:	e9 1a f8 ff ff       	jmp    80106597 <alltraps>

80106d7d <vector70>:
.globl vector70
vector70:
  pushl $0
80106d7d:	6a 00                	push   $0x0
  pushl $70
80106d7f:	6a 46                	push   $0x46
  jmp alltraps
80106d81:	e9 11 f8 ff ff       	jmp    80106597 <alltraps>

80106d86 <vector71>:
.globl vector71
vector71:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $71
80106d88:	6a 47                	push   $0x47
  jmp alltraps
80106d8a:	e9 08 f8 ff ff       	jmp    80106597 <alltraps>

80106d8f <vector72>:
.globl vector72
vector72:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $72
80106d91:	6a 48                	push   $0x48
  jmp alltraps
80106d93:	e9 ff f7 ff ff       	jmp    80106597 <alltraps>

80106d98 <vector73>:
.globl vector73
vector73:
  pushl $0
80106d98:	6a 00                	push   $0x0
  pushl $73
80106d9a:	6a 49                	push   $0x49
  jmp alltraps
80106d9c:	e9 f6 f7 ff ff       	jmp    80106597 <alltraps>

80106da1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106da1:	6a 00                	push   $0x0
  pushl $74
80106da3:	6a 4a                	push   $0x4a
  jmp alltraps
80106da5:	e9 ed f7 ff ff       	jmp    80106597 <alltraps>

80106daa <vector75>:
.globl vector75
vector75:
  pushl $0
80106daa:	6a 00                	push   $0x0
  pushl $75
80106dac:	6a 4b                	push   $0x4b
  jmp alltraps
80106dae:	e9 e4 f7 ff ff       	jmp    80106597 <alltraps>

80106db3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $76
80106db5:	6a 4c                	push   $0x4c
  jmp alltraps
80106db7:	e9 db f7 ff ff       	jmp    80106597 <alltraps>

80106dbc <vector77>:
.globl vector77
vector77:
  pushl $0
80106dbc:	6a 00                	push   $0x0
  pushl $77
80106dbe:	6a 4d                	push   $0x4d
  jmp alltraps
80106dc0:	e9 d2 f7 ff ff       	jmp    80106597 <alltraps>

80106dc5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106dc5:	6a 00                	push   $0x0
  pushl $78
80106dc7:	6a 4e                	push   $0x4e
  jmp alltraps
80106dc9:	e9 c9 f7 ff ff       	jmp    80106597 <alltraps>

80106dce <vector79>:
.globl vector79
vector79:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $79
80106dd0:	6a 4f                	push   $0x4f
  jmp alltraps
80106dd2:	e9 c0 f7 ff ff       	jmp    80106597 <alltraps>

80106dd7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $80
80106dd9:	6a 50                	push   $0x50
  jmp alltraps
80106ddb:	e9 b7 f7 ff ff       	jmp    80106597 <alltraps>

80106de0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106de0:	6a 00                	push   $0x0
  pushl $81
80106de2:	6a 51                	push   $0x51
  jmp alltraps
80106de4:	e9 ae f7 ff ff       	jmp    80106597 <alltraps>

80106de9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106de9:	6a 00                	push   $0x0
  pushl $82
80106deb:	6a 52                	push   $0x52
  jmp alltraps
80106ded:	e9 a5 f7 ff ff       	jmp    80106597 <alltraps>

80106df2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $83
80106df4:	6a 53                	push   $0x53
  jmp alltraps
80106df6:	e9 9c f7 ff ff       	jmp    80106597 <alltraps>

80106dfb <vector84>:
.globl vector84
vector84:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $84
80106dfd:	6a 54                	push   $0x54
  jmp alltraps
80106dff:	e9 93 f7 ff ff       	jmp    80106597 <alltraps>

80106e04 <vector85>:
.globl vector85
vector85:
  pushl $0
80106e04:	6a 00                	push   $0x0
  pushl $85
80106e06:	6a 55                	push   $0x55
  jmp alltraps
80106e08:	e9 8a f7 ff ff       	jmp    80106597 <alltraps>

80106e0d <vector86>:
.globl vector86
vector86:
  pushl $0
80106e0d:	6a 00                	push   $0x0
  pushl $86
80106e0f:	6a 56                	push   $0x56
  jmp alltraps
80106e11:	e9 81 f7 ff ff       	jmp    80106597 <alltraps>

80106e16 <vector87>:
.globl vector87
vector87:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $87
80106e18:	6a 57                	push   $0x57
  jmp alltraps
80106e1a:	e9 78 f7 ff ff       	jmp    80106597 <alltraps>

80106e1f <vector88>:
.globl vector88
vector88:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $88
80106e21:	6a 58                	push   $0x58
  jmp alltraps
80106e23:	e9 6f f7 ff ff       	jmp    80106597 <alltraps>

80106e28 <vector89>:
.globl vector89
vector89:
  pushl $0
80106e28:	6a 00                	push   $0x0
  pushl $89
80106e2a:	6a 59                	push   $0x59
  jmp alltraps
80106e2c:	e9 66 f7 ff ff       	jmp    80106597 <alltraps>

80106e31 <vector90>:
.globl vector90
vector90:
  pushl $0
80106e31:	6a 00                	push   $0x0
  pushl $90
80106e33:	6a 5a                	push   $0x5a
  jmp alltraps
80106e35:	e9 5d f7 ff ff       	jmp    80106597 <alltraps>

80106e3a <vector91>:
.globl vector91
vector91:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $91
80106e3c:	6a 5b                	push   $0x5b
  jmp alltraps
80106e3e:	e9 54 f7 ff ff       	jmp    80106597 <alltraps>

80106e43 <vector92>:
.globl vector92
vector92:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $92
80106e45:	6a 5c                	push   $0x5c
  jmp alltraps
80106e47:	e9 4b f7 ff ff       	jmp    80106597 <alltraps>

80106e4c <vector93>:
.globl vector93
vector93:
  pushl $0
80106e4c:	6a 00                	push   $0x0
  pushl $93
80106e4e:	6a 5d                	push   $0x5d
  jmp alltraps
80106e50:	e9 42 f7 ff ff       	jmp    80106597 <alltraps>

80106e55 <vector94>:
.globl vector94
vector94:
  pushl $0
80106e55:	6a 00                	push   $0x0
  pushl $94
80106e57:	6a 5e                	push   $0x5e
  jmp alltraps
80106e59:	e9 39 f7 ff ff       	jmp    80106597 <alltraps>

80106e5e <vector95>:
.globl vector95
vector95:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $95
80106e60:	6a 5f                	push   $0x5f
  jmp alltraps
80106e62:	e9 30 f7 ff ff       	jmp    80106597 <alltraps>

80106e67 <vector96>:
.globl vector96
vector96:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $96
80106e69:	6a 60                	push   $0x60
  jmp alltraps
80106e6b:	e9 27 f7 ff ff       	jmp    80106597 <alltraps>

80106e70 <vector97>:
.globl vector97
vector97:
  pushl $0
80106e70:	6a 00                	push   $0x0
  pushl $97
80106e72:	6a 61                	push   $0x61
  jmp alltraps
80106e74:	e9 1e f7 ff ff       	jmp    80106597 <alltraps>

80106e79 <vector98>:
.globl vector98
vector98:
  pushl $0
80106e79:	6a 00                	push   $0x0
  pushl $98
80106e7b:	6a 62                	push   $0x62
  jmp alltraps
80106e7d:	e9 15 f7 ff ff       	jmp    80106597 <alltraps>

80106e82 <vector99>:
.globl vector99
vector99:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $99
80106e84:	6a 63                	push   $0x63
  jmp alltraps
80106e86:	e9 0c f7 ff ff       	jmp    80106597 <alltraps>

80106e8b <vector100>:
.globl vector100
vector100:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $100
80106e8d:	6a 64                	push   $0x64
  jmp alltraps
80106e8f:	e9 03 f7 ff ff       	jmp    80106597 <alltraps>

80106e94 <vector101>:
.globl vector101
vector101:
  pushl $0
80106e94:	6a 00                	push   $0x0
  pushl $101
80106e96:	6a 65                	push   $0x65
  jmp alltraps
80106e98:	e9 fa f6 ff ff       	jmp    80106597 <alltraps>

80106e9d <vector102>:
.globl vector102
vector102:
  pushl $0
80106e9d:	6a 00                	push   $0x0
  pushl $102
80106e9f:	6a 66                	push   $0x66
  jmp alltraps
80106ea1:	e9 f1 f6 ff ff       	jmp    80106597 <alltraps>

80106ea6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $103
80106ea8:	6a 67                	push   $0x67
  jmp alltraps
80106eaa:	e9 e8 f6 ff ff       	jmp    80106597 <alltraps>

80106eaf <vector104>:
.globl vector104
vector104:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $104
80106eb1:	6a 68                	push   $0x68
  jmp alltraps
80106eb3:	e9 df f6 ff ff       	jmp    80106597 <alltraps>

80106eb8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106eb8:	6a 00                	push   $0x0
  pushl $105
80106eba:	6a 69                	push   $0x69
  jmp alltraps
80106ebc:	e9 d6 f6 ff ff       	jmp    80106597 <alltraps>

80106ec1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ec1:	6a 00                	push   $0x0
  pushl $106
80106ec3:	6a 6a                	push   $0x6a
  jmp alltraps
80106ec5:	e9 cd f6 ff ff       	jmp    80106597 <alltraps>

80106eca <vector107>:
.globl vector107
vector107:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $107
80106ecc:	6a 6b                	push   $0x6b
  jmp alltraps
80106ece:	e9 c4 f6 ff ff       	jmp    80106597 <alltraps>

80106ed3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $108
80106ed5:	6a 6c                	push   $0x6c
  jmp alltraps
80106ed7:	e9 bb f6 ff ff       	jmp    80106597 <alltraps>

80106edc <vector109>:
.globl vector109
vector109:
  pushl $0
80106edc:	6a 00                	push   $0x0
  pushl $109
80106ede:	6a 6d                	push   $0x6d
  jmp alltraps
80106ee0:	e9 b2 f6 ff ff       	jmp    80106597 <alltraps>

80106ee5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ee5:	6a 00                	push   $0x0
  pushl $110
80106ee7:	6a 6e                	push   $0x6e
  jmp alltraps
80106ee9:	e9 a9 f6 ff ff       	jmp    80106597 <alltraps>

80106eee <vector111>:
.globl vector111
vector111:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $111
80106ef0:	6a 6f                	push   $0x6f
  jmp alltraps
80106ef2:	e9 a0 f6 ff ff       	jmp    80106597 <alltraps>

80106ef7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $112
80106ef9:	6a 70                	push   $0x70
  jmp alltraps
80106efb:	e9 97 f6 ff ff       	jmp    80106597 <alltraps>

80106f00 <vector113>:
.globl vector113
vector113:
  pushl $0
80106f00:	6a 00                	push   $0x0
  pushl $113
80106f02:	6a 71                	push   $0x71
  jmp alltraps
80106f04:	e9 8e f6 ff ff       	jmp    80106597 <alltraps>

80106f09 <vector114>:
.globl vector114
vector114:
  pushl $0
80106f09:	6a 00                	push   $0x0
  pushl $114
80106f0b:	6a 72                	push   $0x72
  jmp alltraps
80106f0d:	e9 85 f6 ff ff       	jmp    80106597 <alltraps>

80106f12 <vector115>:
.globl vector115
vector115:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $115
80106f14:	6a 73                	push   $0x73
  jmp alltraps
80106f16:	e9 7c f6 ff ff       	jmp    80106597 <alltraps>

80106f1b <vector116>:
.globl vector116
vector116:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $116
80106f1d:	6a 74                	push   $0x74
  jmp alltraps
80106f1f:	e9 73 f6 ff ff       	jmp    80106597 <alltraps>

80106f24 <vector117>:
.globl vector117
vector117:
  pushl $0
80106f24:	6a 00                	push   $0x0
  pushl $117
80106f26:	6a 75                	push   $0x75
  jmp alltraps
80106f28:	e9 6a f6 ff ff       	jmp    80106597 <alltraps>

80106f2d <vector118>:
.globl vector118
vector118:
  pushl $0
80106f2d:	6a 00                	push   $0x0
  pushl $118
80106f2f:	6a 76                	push   $0x76
  jmp alltraps
80106f31:	e9 61 f6 ff ff       	jmp    80106597 <alltraps>

80106f36 <vector119>:
.globl vector119
vector119:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $119
80106f38:	6a 77                	push   $0x77
  jmp alltraps
80106f3a:	e9 58 f6 ff ff       	jmp    80106597 <alltraps>

80106f3f <vector120>:
.globl vector120
vector120:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $120
80106f41:	6a 78                	push   $0x78
  jmp alltraps
80106f43:	e9 4f f6 ff ff       	jmp    80106597 <alltraps>

80106f48 <vector121>:
.globl vector121
vector121:
  pushl $0
80106f48:	6a 00                	push   $0x0
  pushl $121
80106f4a:	6a 79                	push   $0x79
  jmp alltraps
80106f4c:	e9 46 f6 ff ff       	jmp    80106597 <alltraps>

80106f51 <vector122>:
.globl vector122
vector122:
  pushl $0
80106f51:	6a 00                	push   $0x0
  pushl $122
80106f53:	6a 7a                	push   $0x7a
  jmp alltraps
80106f55:	e9 3d f6 ff ff       	jmp    80106597 <alltraps>

80106f5a <vector123>:
.globl vector123
vector123:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $123
80106f5c:	6a 7b                	push   $0x7b
  jmp alltraps
80106f5e:	e9 34 f6 ff ff       	jmp    80106597 <alltraps>

80106f63 <vector124>:
.globl vector124
vector124:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $124
80106f65:	6a 7c                	push   $0x7c
  jmp alltraps
80106f67:	e9 2b f6 ff ff       	jmp    80106597 <alltraps>

80106f6c <vector125>:
.globl vector125
vector125:
  pushl $0
80106f6c:	6a 00                	push   $0x0
  pushl $125
80106f6e:	6a 7d                	push   $0x7d
  jmp alltraps
80106f70:	e9 22 f6 ff ff       	jmp    80106597 <alltraps>

80106f75 <vector126>:
.globl vector126
vector126:
  pushl $0
80106f75:	6a 00                	push   $0x0
  pushl $126
80106f77:	6a 7e                	push   $0x7e
  jmp alltraps
80106f79:	e9 19 f6 ff ff       	jmp    80106597 <alltraps>

80106f7e <vector127>:
.globl vector127
vector127:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $127
80106f80:	6a 7f                	push   $0x7f
  jmp alltraps
80106f82:	e9 10 f6 ff ff       	jmp    80106597 <alltraps>

80106f87 <vector128>:
.globl vector128
vector128:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $128
80106f89:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106f8e:	e9 04 f6 ff ff       	jmp    80106597 <alltraps>

80106f93 <vector129>:
.globl vector129
vector129:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $129
80106f95:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106f9a:	e9 f8 f5 ff ff       	jmp    80106597 <alltraps>

80106f9f <vector130>:
.globl vector130
vector130:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $130
80106fa1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106fa6:	e9 ec f5 ff ff       	jmp    80106597 <alltraps>

80106fab <vector131>:
.globl vector131
vector131:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $131
80106fad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106fb2:	e9 e0 f5 ff ff       	jmp    80106597 <alltraps>

80106fb7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $132
80106fb9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106fbe:	e9 d4 f5 ff ff       	jmp    80106597 <alltraps>

80106fc3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $133
80106fc5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106fca:	e9 c8 f5 ff ff       	jmp    80106597 <alltraps>

80106fcf <vector134>:
.globl vector134
vector134:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $134
80106fd1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106fd6:	e9 bc f5 ff ff       	jmp    80106597 <alltraps>

80106fdb <vector135>:
.globl vector135
vector135:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $135
80106fdd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106fe2:	e9 b0 f5 ff ff       	jmp    80106597 <alltraps>

80106fe7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $136
80106fe9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106fee:	e9 a4 f5 ff ff       	jmp    80106597 <alltraps>

80106ff3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $137
80106ff5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106ffa:	e9 98 f5 ff ff       	jmp    80106597 <alltraps>

80106fff <vector138>:
.globl vector138
vector138:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $138
80107001:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107006:	e9 8c f5 ff ff       	jmp    80106597 <alltraps>

8010700b <vector139>:
.globl vector139
vector139:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $139
8010700d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107012:	e9 80 f5 ff ff       	jmp    80106597 <alltraps>

80107017 <vector140>:
.globl vector140
vector140:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $140
80107019:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010701e:	e9 74 f5 ff ff       	jmp    80106597 <alltraps>

80107023 <vector141>:
.globl vector141
vector141:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $141
80107025:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010702a:	e9 68 f5 ff ff       	jmp    80106597 <alltraps>

8010702f <vector142>:
.globl vector142
vector142:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $142
80107031:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107036:	e9 5c f5 ff ff       	jmp    80106597 <alltraps>

8010703b <vector143>:
.globl vector143
vector143:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $143
8010703d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107042:	e9 50 f5 ff ff       	jmp    80106597 <alltraps>

80107047 <vector144>:
.globl vector144
vector144:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $144
80107049:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010704e:	e9 44 f5 ff ff       	jmp    80106597 <alltraps>

80107053 <vector145>:
.globl vector145
vector145:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $145
80107055:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010705a:	e9 38 f5 ff ff       	jmp    80106597 <alltraps>

8010705f <vector146>:
.globl vector146
vector146:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $146
80107061:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107066:	e9 2c f5 ff ff       	jmp    80106597 <alltraps>

8010706b <vector147>:
.globl vector147
vector147:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $147
8010706d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107072:	e9 20 f5 ff ff       	jmp    80106597 <alltraps>

80107077 <vector148>:
.globl vector148
vector148:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $148
80107079:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010707e:	e9 14 f5 ff ff       	jmp    80106597 <alltraps>

80107083 <vector149>:
.globl vector149
vector149:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $149
80107085:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010708a:	e9 08 f5 ff ff       	jmp    80106597 <alltraps>

8010708f <vector150>:
.globl vector150
vector150:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $150
80107091:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107096:	e9 fc f4 ff ff       	jmp    80106597 <alltraps>

8010709b <vector151>:
.globl vector151
vector151:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $151
8010709d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801070a2:	e9 f0 f4 ff ff       	jmp    80106597 <alltraps>

801070a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $152
801070a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801070ae:	e9 e4 f4 ff ff       	jmp    80106597 <alltraps>

801070b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $153
801070b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801070ba:	e9 d8 f4 ff ff       	jmp    80106597 <alltraps>

801070bf <vector154>:
.globl vector154
vector154:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $154
801070c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801070c6:	e9 cc f4 ff ff       	jmp    80106597 <alltraps>

801070cb <vector155>:
.globl vector155
vector155:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $155
801070cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801070d2:	e9 c0 f4 ff ff       	jmp    80106597 <alltraps>

801070d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $156
801070d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801070de:	e9 b4 f4 ff ff       	jmp    80106597 <alltraps>

801070e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $157
801070e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801070ea:	e9 a8 f4 ff ff       	jmp    80106597 <alltraps>

801070ef <vector158>:
.globl vector158
vector158:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $158
801070f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801070f6:	e9 9c f4 ff ff       	jmp    80106597 <alltraps>

801070fb <vector159>:
.globl vector159
vector159:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $159
801070fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107102:	e9 90 f4 ff ff       	jmp    80106597 <alltraps>

80107107 <vector160>:
.globl vector160
vector160:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $160
80107109:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010710e:	e9 84 f4 ff ff       	jmp    80106597 <alltraps>

80107113 <vector161>:
.globl vector161
vector161:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $161
80107115:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010711a:	e9 78 f4 ff ff       	jmp    80106597 <alltraps>

8010711f <vector162>:
.globl vector162
vector162:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $162
80107121:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107126:	e9 6c f4 ff ff       	jmp    80106597 <alltraps>

8010712b <vector163>:
.globl vector163
vector163:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $163
8010712d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107132:	e9 60 f4 ff ff       	jmp    80106597 <alltraps>

80107137 <vector164>:
.globl vector164
vector164:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $164
80107139:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010713e:	e9 54 f4 ff ff       	jmp    80106597 <alltraps>

80107143 <vector165>:
.globl vector165
vector165:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $165
80107145:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010714a:	e9 48 f4 ff ff       	jmp    80106597 <alltraps>

8010714f <vector166>:
.globl vector166
vector166:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $166
80107151:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107156:	e9 3c f4 ff ff       	jmp    80106597 <alltraps>

8010715b <vector167>:
.globl vector167
vector167:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $167
8010715d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107162:	e9 30 f4 ff ff       	jmp    80106597 <alltraps>

80107167 <vector168>:
.globl vector168
vector168:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $168
80107169:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010716e:	e9 24 f4 ff ff       	jmp    80106597 <alltraps>

80107173 <vector169>:
.globl vector169
vector169:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $169
80107175:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010717a:	e9 18 f4 ff ff       	jmp    80106597 <alltraps>

8010717f <vector170>:
.globl vector170
vector170:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $170
80107181:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107186:	e9 0c f4 ff ff       	jmp    80106597 <alltraps>

8010718b <vector171>:
.globl vector171
vector171:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $171
8010718d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107192:	e9 00 f4 ff ff       	jmp    80106597 <alltraps>

80107197 <vector172>:
.globl vector172
vector172:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $172
80107199:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010719e:	e9 f4 f3 ff ff       	jmp    80106597 <alltraps>

801071a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $173
801071a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801071aa:	e9 e8 f3 ff ff       	jmp    80106597 <alltraps>

801071af <vector174>:
.globl vector174
vector174:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $174
801071b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801071b6:	e9 dc f3 ff ff       	jmp    80106597 <alltraps>

801071bb <vector175>:
.globl vector175
vector175:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $175
801071bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801071c2:	e9 d0 f3 ff ff       	jmp    80106597 <alltraps>

801071c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $176
801071c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801071ce:	e9 c4 f3 ff ff       	jmp    80106597 <alltraps>

801071d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $177
801071d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801071da:	e9 b8 f3 ff ff       	jmp    80106597 <alltraps>

801071df <vector178>:
.globl vector178
vector178:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $178
801071e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801071e6:	e9 ac f3 ff ff       	jmp    80106597 <alltraps>

801071eb <vector179>:
.globl vector179
vector179:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $179
801071ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801071f2:	e9 a0 f3 ff ff       	jmp    80106597 <alltraps>

801071f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $180
801071f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801071fe:	e9 94 f3 ff ff       	jmp    80106597 <alltraps>

80107203 <vector181>:
.globl vector181
vector181:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $181
80107205:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010720a:	e9 88 f3 ff ff       	jmp    80106597 <alltraps>

8010720f <vector182>:
.globl vector182
vector182:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $182
80107211:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107216:	e9 7c f3 ff ff       	jmp    80106597 <alltraps>

8010721b <vector183>:
.globl vector183
vector183:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $183
8010721d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107222:	e9 70 f3 ff ff       	jmp    80106597 <alltraps>

80107227 <vector184>:
.globl vector184
vector184:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $184
80107229:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010722e:	e9 64 f3 ff ff       	jmp    80106597 <alltraps>

80107233 <vector185>:
.globl vector185
vector185:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $185
80107235:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010723a:	e9 58 f3 ff ff       	jmp    80106597 <alltraps>

8010723f <vector186>:
.globl vector186
vector186:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $186
80107241:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107246:	e9 4c f3 ff ff       	jmp    80106597 <alltraps>

8010724b <vector187>:
.globl vector187
vector187:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $187
8010724d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107252:	e9 40 f3 ff ff       	jmp    80106597 <alltraps>

80107257 <vector188>:
.globl vector188
vector188:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $188
80107259:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010725e:	e9 34 f3 ff ff       	jmp    80106597 <alltraps>

80107263 <vector189>:
.globl vector189
vector189:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $189
80107265:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010726a:	e9 28 f3 ff ff       	jmp    80106597 <alltraps>

8010726f <vector190>:
.globl vector190
vector190:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $190
80107271:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107276:	e9 1c f3 ff ff       	jmp    80106597 <alltraps>

8010727b <vector191>:
.globl vector191
vector191:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $191
8010727d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107282:	e9 10 f3 ff ff       	jmp    80106597 <alltraps>

80107287 <vector192>:
.globl vector192
vector192:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $192
80107289:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010728e:	e9 04 f3 ff ff       	jmp    80106597 <alltraps>

80107293 <vector193>:
.globl vector193
vector193:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $193
80107295:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010729a:	e9 f8 f2 ff ff       	jmp    80106597 <alltraps>

8010729f <vector194>:
.globl vector194
vector194:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $194
801072a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801072a6:	e9 ec f2 ff ff       	jmp    80106597 <alltraps>

801072ab <vector195>:
.globl vector195
vector195:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $195
801072ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801072b2:	e9 e0 f2 ff ff       	jmp    80106597 <alltraps>

801072b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $196
801072b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801072be:	e9 d4 f2 ff ff       	jmp    80106597 <alltraps>

801072c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $197
801072c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801072ca:	e9 c8 f2 ff ff       	jmp    80106597 <alltraps>

801072cf <vector198>:
.globl vector198
vector198:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $198
801072d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801072d6:	e9 bc f2 ff ff       	jmp    80106597 <alltraps>

801072db <vector199>:
.globl vector199
vector199:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $199
801072dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801072e2:	e9 b0 f2 ff ff       	jmp    80106597 <alltraps>

801072e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $200
801072e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801072ee:	e9 a4 f2 ff ff       	jmp    80106597 <alltraps>

801072f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $201
801072f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801072fa:	e9 98 f2 ff ff       	jmp    80106597 <alltraps>

801072ff <vector202>:
.globl vector202
vector202:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $202
80107301:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107306:	e9 8c f2 ff ff       	jmp    80106597 <alltraps>

8010730b <vector203>:
.globl vector203
vector203:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $203
8010730d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107312:	e9 80 f2 ff ff       	jmp    80106597 <alltraps>

80107317 <vector204>:
.globl vector204
vector204:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $204
80107319:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010731e:	e9 74 f2 ff ff       	jmp    80106597 <alltraps>

80107323 <vector205>:
.globl vector205
vector205:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $205
80107325:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010732a:	e9 68 f2 ff ff       	jmp    80106597 <alltraps>

8010732f <vector206>:
.globl vector206
vector206:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $206
80107331:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107336:	e9 5c f2 ff ff       	jmp    80106597 <alltraps>

8010733b <vector207>:
.globl vector207
vector207:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $207
8010733d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107342:	e9 50 f2 ff ff       	jmp    80106597 <alltraps>

80107347 <vector208>:
.globl vector208
vector208:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $208
80107349:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010734e:	e9 44 f2 ff ff       	jmp    80106597 <alltraps>

80107353 <vector209>:
.globl vector209
vector209:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $209
80107355:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010735a:	e9 38 f2 ff ff       	jmp    80106597 <alltraps>

8010735f <vector210>:
.globl vector210
vector210:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $210
80107361:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107366:	e9 2c f2 ff ff       	jmp    80106597 <alltraps>

8010736b <vector211>:
.globl vector211
vector211:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $211
8010736d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107372:	e9 20 f2 ff ff       	jmp    80106597 <alltraps>

80107377 <vector212>:
.globl vector212
vector212:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $212
80107379:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010737e:	e9 14 f2 ff ff       	jmp    80106597 <alltraps>

80107383 <vector213>:
.globl vector213
vector213:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $213
80107385:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010738a:	e9 08 f2 ff ff       	jmp    80106597 <alltraps>

8010738f <vector214>:
.globl vector214
vector214:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $214
80107391:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107396:	e9 fc f1 ff ff       	jmp    80106597 <alltraps>

8010739b <vector215>:
.globl vector215
vector215:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $215
8010739d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801073a2:	e9 f0 f1 ff ff       	jmp    80106597 <alltraps>

801073a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $216
801073a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801073ae:	e9 e4 f1 ff ff       	jmp    80106597 <alltraps>

801073b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $217
801073b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801073ba:	e9 d8 f1 ff ff       	jmp    80106597 <alltraps>

801073bf <vector218>:
.globl vector218
vector218:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $218
801073c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801073c6:	e9 cc f1 ff ff       	jmp    80106597 <alltraps>

801073cb <vector219>:
.globl vector219
vector219:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $219
801073cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801073d2:	e9 c0 f1 ff ff       	jmp    80106597 <alltraps>

801073d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $220
801073d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801073de:	e9 b4 f1 ff ff       	jmp    80106597 <alltraps>

801073e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $221
801073e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801073ea:	e9 a8 f1 ff ff       	jmp    80106597 <alltraps>

801073ef <vector222>:
.globl vector222
vector222:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $222
801073f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801073f6:	e9 9c f1 ff ff       	jmp    80106597 <alltraps>

801073fb <vector223>:
.globl vector223
vector223:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $223
801073fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107402:	e9 90 f1 ff ff       	jmp    80106597 <alltraps>

80107407 <vector224>:
.globl vector224
vector224:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $224
80107409:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010740e:	e9 84 f1 ff ff       	jmp    80106597 <alltraps>

80107413 <vector225>:
.globl vector225
vector225:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $225
80107415:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010741a:	e9 78 f1 ff ff       	jmp    80106597 <alltraps>

8010741f <vector226>:
.globl vector226
vector226:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $226
80107421:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107426:	e9 6c f1 ff ff       	jmp    80106597 <alltraps>

8010742b <vector227>:
.globl vector227
vector227:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $227
8010742d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107432:	e9 60 f1 ff ff       	jmp    80106597 <alltraps>

80107437 <vector228>:
.globl vector228
vector228:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $228
80107439:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010743e:	e9 54 f1 ff ff       	jmp    80106597 <alltraps>

80107443 <vector229>:
.globl vector229
vector229:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $229
80107445:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010744a:	e9 48 f1 ff ff       	jmp    80106597 <alltraps>

8010744f <vector230>:
.globl vector230
vector230:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $230
80107451:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107456:	e9 3c f1 ff ff       	jmp    80106597 <alltraps>

8010745b <vector231>:
.globl vector231
vector231:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $231
8010745d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107462:	e9 30 f1 ff ff       	jmp    80106597 <alltraps>

80107467 <vector232>:
.globl vector232
vector232:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $232
80107469:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010746e:	e9 24 f1 ff ff       	jmp    80106597 <alltraps>

80107473 <vector233>:
.globl vector233
vector233:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $233
80107475:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010747a:	e9 18 f1 ff ff       	jmp    80106597 <alltraps>

8010747f <vector234>:
.globl vector234
vector234:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $234
80107481:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107486:	e9 0c f1 ff ff       	jmp    80106597 <alltraps>

8010748b <vector235>:
.globl vector235
vector235:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $235
8010748d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107492:	e9 00 f1 ff ff       	jmp    80106597 <alltraps>

80107497 <vector236>:
.globl vector236
vector236:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $236
80107499:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010749e:	e9 f4 f0 ff ff       	jmp    80106597 <alltraps>

801074a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $237
801074a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801074aa:	e9 e8 f0 ff ff       	jmp    80106597 <alltraps>

801074af <vector238>:
.globl vector238
vector238:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $238
801074b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801074b6:	e9 dc f0 ff ff       	jmp    80106597 <alltraps>

801074bb <vector239>:
.globl vector239
vector239:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $239
801074bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801074c2:	e9 d0 f0 ff ff       	jmp    80106597 <alltraps>

801074c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $240
801074c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801074ce:	e9 c4 f0 ff ff       	jmp    80106597 <alltraps>

801074d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $241
801074d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801074da:	e9 b8 f0 ff ff       	jmp    80106597 <alltraps>

801074df <vector242>:
.globl vector242
vector242:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $242
801074e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801074e6:	e9 ac f0 ff ff       	jmp    80106597 <alltraps>

801074eb <vector243>:
.globl vector243
vector243:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $243
801074ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801074f2:	e9 a0 f0 ff ff       	jmp    80106597 <alltraps>

801074f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $244
801074f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801074fe:	e9 94 f0 ff ff       	jmp    80106597 <alltraps>

80107503 <vector245>:
.globl vector245
vector245:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $245
80107505:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010750a:	e9 88 f0 ff ff       	jmp    80106597 <alltraps>

8010750f <vector246>:
.globl vector246
vector246:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $246
80107511:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107516:	e9 7c f0 ff ff       	jmp    80106597 <alltraps>

8010751b <vector247>:
.globl vector247
vector247:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $247
8010751d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107522:	e9 70 f0 ff ff       	jmp    80106597 <alltraps>

80107527 <vector248>:
.globl vector248
vector248:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $248
80107529:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010752e:	e9 64 f0 ff ff       	jmp    80106597 <alltraps>

80107533 <vector249>:
.globl vector249
vector249:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $249
80107535:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010753a:	e9 58 f0 ff ff       	jmp    80106597 <alltraps>

8010753f <vector250>:
.globl vector250
vector250:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $250
80107541:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107546:	e9 4c f0 ff ff       	jmp    80106597 <alltraps>

8010754b <vector251>:
.globl vector251
vector251:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $251
8010754d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107552:	e9 40 f0 ff ff       	jmp    80106597 <alltraps>

80107557 <vector252>:
.globl vector252
vector252:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $252
80107559:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010755e:	e9 34 f0 ff ff       	jmp    80106597 <alltraps>

80107563 <vector253>:
.globl vector253
vector253:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $253
80107565:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010756a:	e9 28 f0 ff ff       	jmp    80106597 <alltraps>

8010756f <vector254>:
.globl vector254
vector254:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $254
80107571:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107576:	e9 1c f0 ff ff       	jmp    80106597 <alltraps>

8010757b <vector255>:
.globl vector255
vector255:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $255
8010757d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107582:	e9 10 f0 ff ff       	jmp    80106597 <alltraps>
80107587:	66 90                	xchg   %ax,%ax
80107589:	66 90                	xchg   %ax,%ax
8010758b:	66 90                	xchg   %ax,%ax
8010758d:	66 90                	xchg   %ax,%ax
8010758f:	90                   	nop

80107590 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	57                   	push   %edi
80107594:	56                   	push   %esi
80107595:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107596:	89 d3                	mov    %edx,%ebx
{
80107598:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010759a:	c1 eb 16             	shr    $0x16,%ebx
8010759d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801075a0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801075a3:	8b 06                	mov    (%esi),%eax
801075a5:	a8 01                	test   $0x1,%al
801075a7:	74 27                	je     801075d0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075ae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801075b4:	c1 ef 0a             	shr    $0xa,%edi
}
801075b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801075ba:	89 fa                	mov    %edi,%edx
801075bc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801075c2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801075c5:	5b                   	pop    %ebx
801075c6:	5e                   	pop    %esi
801075c7:	5f                   	pop    %edi
801075c8:	5d                   	pop    %ebp
801075c9:	c3                   	ret    
801075ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801075d0:	85 c9                	test   %ecx,%ecx
801075d2:	74 2c                	je     80107600 <walkpgdir+0x70>
801075d4:	e8 e7 ae ff ff       	call   801024c0 <kalloc>
801075d9:	85 c0                	test   %eax,%eax
801075db:	89 c3                	mov    %eax,%ebx
801075dd:	74 21                	je     80107600 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801075df:	83 ec 04             	sub    $0x4,%esp
801075e2:	68 00 10 00 00       	push   $0x1000
801075e7:	6a 00                	push   $0x0
801075e9:	50                   	push   %eax
801075ea:	e8 71 dc ff ff       	call   80105260 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801075ef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075f5:	83 c4 10             	add    $0x10,%esp
801075f8:	83 c8 07             	or     $0x7,%eax
801075fb:	89 06                	mov    %eax,(%esi)
801075fd:	eb b5                	jmp    801075b4 <walkpgdir+0x24>
801075ff:	90                   	nop
}
80107600:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107603:	31 c0                	xor    %eax,%eax
}
80107605:	5b                   	pop    %ebx
80107606:	5e                   	pop    %esi
80107607:	5f                   	pop    %edi
80107608:	5d                   	pop    %ebp
80107609:	c3                   	ret    
8010760a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107610 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	57                   	push   %edi
80107614:	56                   	push   %esi
80107615:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107616:	89 d3                	mov    %edx,%ebx
80107618:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010761e:	83 ec 1c             	sub    $0x1c,%esp
80107621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107624:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107628:	8b 7d 08             	mov    0x8(%ebp),%edi
8010762b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107630:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107633:	8b 45 0c             	mov    0xc(%ebp),%eax
80107636:	29 df                	sub    %ebx,%edi
80107638:	83 c8 01             	or     $0x1,%eax
8010763b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010763e:	eb 15                	jmp    80107655 <mappages+0x45>
    if(*pte & PTE_P)
80107640:	f6 00 01             	testb  $0x1,(%eax)
80107643:	75 45                	jne    8010768a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107645:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107648:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010764b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010764d:	74 31                	je     80107680 <mappages+0x70>
      break;
    a += PGSIZE;
8010764f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107658:	b9 01 00 00 00       	mov    $0x1,%ecx
8010765d:	89 da                	mov    %ebx,%edx
8010765f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107662:	e8 29 ff ff ff       	call   80107590 <walkpgdir>
80107667:	85 c0                	test   %eax,%eax
80107669:	75 d5                	jne    80107640 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010766b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010766e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107673:	5b                   	pop    %ebx
80107674:	5e                   	pop    %esi
80107675:	5f                   	pop    %edi
80107676:	5d                   	pop    %ebp
80107677:	c3                   	ret    
80107678:	90                   	nop
80107679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107680:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107683:	31 c0                	xor    %eax,%eax
}
80107685:	5b                   	pop    %ebx
80107686:	5e                   	pop    %esi
80107687:	5f                   	pop    %edi
80107688:	5d                   	pop    %ebp
80107689:	c3                   	ret    
      panic("remap");
8010768a:	83 ec 0c             	sub    $0xc,%esp
8010768d:	68 80 88 10 80       	push   $0x80108880
80107692:	e8 f9 8c ff ff       	call   80100390 <panic>
80107697:	89 f6                	mov    %esi,%esi
80107699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801076a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801076ac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801076ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801076b4:	83 ec 1c             	sub    $0x1c,%esp
801076b7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801076ba:	39 d3                	cmp    %edx,%ebx
801076bc:	73 66                	jae    80107724 <deallocuvm.part.0+0x84>
801076be:	89 d6                	mov    %edx,%esi
801076c0:	eb 3d                	jmp    801076ff <deallocuvm.part.0+0x5f>
801076c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801076c8:	8b 10                	mov    (%eax),%edx
801076ca:	f6 c2 01             	test   $0x1,%dl
801076cd:	74 26                	je     801076f5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801076cf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801076d5:	74 58                	je     8010772f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801076d7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801076da:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801076e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801076e3:	52                   	push   %edx
801076e4:	e8 27 ac ff ff       	call   80102310 <kfree>
      *pte = 0;
801076e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076ec:	83 c4 10             	add    $0x10,%esp
801076ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801076f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076fb:	39 f3                	cmp    %esi,%ebx
801076fd:	73 25                	jae    80107724 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801076ff:	31 c9                	xor    %ecx,%ecx
80107701:	89 da                	mov    %ebx,%edx
80107703:	89 f8                	mov    %edi,%eax
80107705:	e8 86 fe ff ff       	call   80107590 <walkpgdir>
    if(!pte)
8010770a:	85 c0                	test   %eax,%eax
8010770c:	75 ba                	jne    801076c8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010770e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107714:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010771a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107720:	39 f3                	cmp    %esi,%ebx
80107722:	72 db                	jb     801076ff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107724:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010772a:	5b                   	pop    %ebx
8010772b:	5e                   	pop    %esi
8010772c:	5f                   	pop    %edi
8010772d:	5d                   	pop    %ebp
8010772e:	c3                   	ret    
        panic("kfree");
8010772f:	83 ec 0c             	sub    $0xc,%esp
80107732:	68 26 81 10 80       	push   $0x80108126
80107737:	e8 54 8c ff ff       	call   80100390 <panic>
8010773c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107740 <seginit>:
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107746:	e8 b5 c4 ff ff       	call   80103c00 <cpuid>
8010774b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107751:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107756:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010775a:	c7 80 18 39 11 80 ff 	movl   $0xffff,-0x7feec6e8(%eax)
80107761:	ff 00 00 
80107764:	c7 80 1c 39 11 80 00 	movl   $0xcf9a00,-0x7feec6e4(%eax)
8010776b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010776e:	c7 80 20 39 11 80 ff 	movl   $0xffff,-0x7feec6e0(%eax)
80107775:	ff 00 00 
80107778:	c7 80 24 39 11 80 00 	movl   $0xcf9200,-0x7feec6dc(%eax)
8010777f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107782:	c7 80 28 39 11 80 ff 	movl   $0xffff,-0x7feec6d8(%eax)
80107789:	ff 00 00 
8010778c:	c7 80 2c 39 11 80 00 	movl   $0xcffa00,-0x7feec6d4(%eax)
80107793:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107796:	c7 80 30 39 11 80 ff 	movl   $0xffff,-0x7feec6d0(%eax)
8010779d:	ff 00 00 
801077a0:	c7 80 34 39 11 80 00 	movl   $0xcff200,-0x7feec6cc(%eax)
801077a7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801077aa:	05 10 39 11 80       	add    $0x80113910,%eax
  pd[1] = (uint)p;
801077af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801077b3:	c1 e8 10             	shr    $0x10,%eax
801077b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801077ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801077bd:	0f 01 10             	lgdtl  (%eax)
}
801077c0:	c9                   	leave  
801077c1:	c3                   	ret    
801077c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077d0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077d0:	a1 04 74 11 80       	mov    0x80117404,%eax
{
801077d5:	55                   	push   %ebp
801077d6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077d8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077dd:	0f 22 d8             	mov    %eax,%cr3
}
801077e0:	5d                   	pop    %ebp
801077e1:	c3                   	ret    
801077e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077f0 <switchuvm>:
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	57                   	push   %edi
801077f4:	56                   	push   %esi
801077f5:	53                   	push   %ebx
801077f6:	83 ec 1c             	sub    $0x1c,%esp
801077f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801077fc:	85 db                	test   %ebx,%ebx
801077fe:	0f 84 cb 00 00 00    	je     801078cf <switchuvm+0xdf>
  if(p->kstack == 0)
80107804:	8b 43 0c             	mov    0xc(%ebx),%eax
80107807:	85 c0                	test   %eax,%eax
80107809:	0f 84 da 00 00 00    	je     801078e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010780f:	8b 43 08             	mov    0x8(%ebx),%eax
80107812:	85 c0                	test   %eax,%eax
80107814:	0f 84 c2 00 00 00    	je     801078dc <switchuvm+0xec>
  pushcli();
8010781a:	e8 61 d8 ff ff       	call   80105080 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010781f:	e8 5c c3 ff ff       	call   80103b80 <mycpu>
80107824:	89 c6                	mov    %eax,%esi
80107826:	e8 55 c3 ff ff       	call   80103b80 <mycpu>
8010782b:	89 c7                	mov    %eax,%edi
8010782d:	e8 4e c3 ff ff       	call   80103b80 <mycpu>
80107832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107835:	83 c7 08             	add    $0x8,%edi
80107838:	e8 43 c3 ff ff       	call   80103b80 <mycpu>
8010783d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107840:	83 c0 08             	add    $0x8,%eax
80107843:	ba 67 00 00 00       	mov    $0x67,%edx
80107848:	c1 e8 18             	shr    $0x18,%eax
8010784b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107852:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107859:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010785f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107864:	83 c1 08             	add    $0x8,%ecx
80107867:	c1 e9 10             	shr    $0x10,%ecx
8010786a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107870:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107875:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010787c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107881:	e8 fa c2 ff ff       	call   80103b80 <mycpu>
80107886:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010788d:	e8 ee c2 ff ff       	call   80103b80 <mycpu>
80107892:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107896:	8b 73 0c             	mov    0xc(%ebx),%esi
80107899:	e8 e2 c2 ff ff       	call   80103b80 <mycpu>
8010789e:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078a4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078a7:	e8 d4 c2 ff ff       	call   80103b80 <mycpu>
801078ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801078b0:	b8 28 00 00 00       	mov    $0x28,%eax
801078b5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801078b8:	8b 43 08             	mov    0x8(%ebx),%eax
801078bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801078c0:	0f 22 d8             	mov    %eax,%cr3
}
801078c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078c6:	5b                   	pop    %ebx
801078c7:	5e                   	pop    %esi
801078c8:	5f                   	pop    %edi
801078c9:	5d                   	pop    %ebp
  popcli();
801078ca:	e9 f1 d7 ff ff       	jmp    801050c0 <popcli>
    panic("switchuvm: no process");
801078cf:	83 ec 0c             	sub    $0xc,%esp
801078d2:	68 86 88 10 80       	push   $0x80108886
801078d7:	e8 b4 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801078dc:	83 ec 0c             	sub    $0xc,%esp
801078df:	68 b1 88 10 80       	push   $0x801088b1
801078e4:	e8 a7 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801078e9:	83 ec 0c             	sub    $0xc,%esp
801078ec:	68 9c 88 10 80       	push   $0x8010889c
801078f1:	e8 9a 8a ff ff       	call   80100390 <panic>
801078f6:	8d 76 00             	lea    0x0(%esi),%esi
801078f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107900 <inituvm>:
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	57                   	push   %edi
80107904:	56                   	push   %esi
80107905:	53                   	push   %ebx
80107906:	83 ec 1c             	sub    $0x1c,%esp
80107909:	8b 75 10             	mov    0x10(%ebp),%esi
8010790c:	8b 45 08             	mov    0x8(%ebp),%eax
8010790f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107912:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107918:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010791b:	77 49                	ja     80107966 <inituvm+0x66>
  mem = kalloc();
8010791d:	e8 9e ab ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107922:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107925:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107927:	68 00 10 00 00       	push   $0x1000
8010792c:	6a 00                	push   $0x0
8010792e:	50                   	push   %eax
8010792f:	e8 2c d9 ff ff       	call   80105260 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107934:	58                   	pop    %eax
80107935:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010793b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107940:	5a                   	pop    %edx
80107941:	6a 06                	push   $0x6
80107943:	50                   	push   %eax
80107944:	31 d2                	xor    %edx,%edx
80107946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107949:	e8 c2 fc ff ff       	call   80107610 <mappages>
  memmove(mem, init, sz);
8010794e:	89 75 10             	mov    %esi,0x10(%ebp)
80107951:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107954:	83 c4 10             	add    $0x10,%esp
80107957:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010795a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795d:	5b                   	pop    %ebx
8010795e:	5e                   	pop    %esi
8010795f:	5f                   	pop    %edi
80107960:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107961:	e9 aa d9 ff ff       	jmp    80105310 <memmove>
    panic("inituvm: more than a page");
80107966:	83 ec 0c             	sub    $0xc,%esp
80107969:	68 c5 88 10 80       	push   $0x801088c5
8010796e:	e8 1d 8a ff ff       	call   80100390 <panic>
80107973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107980 <loaduvm>:
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	57                   	push   %edi
80107984:	56                   	push   %esi
80107985:	53                   	push   %ebx
80107986:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107989:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107990:	0f 85 91 00 00 00    	jne    80107a27 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107996:	8b 75 18             	mov    0x18(%ebp),%esi
80107999:	31 db                	xor    %ebx,%ebx
8010799b:	85 f6                	test   %esi,%esi
8010799d:	75 1a                	jne    801079b9 <loaduvm+0x39>
8010799f:	eb 6f                	jmp    80107a10 <loaduvm+0x90>
801079a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801079ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801079b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801079b7:	76 57                	jbe    80107a10 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801079b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801079bc:	8b 45 08             	mov    0x8(%ebp),%eax
801079bf:	31 c9                	xor    %ecx,%ecx
801079c1:	01 da                	add    %ebx,%edx
801079c3:	e8 c8 fb ff ff       	call   80107590 <walkpgdir>
801079c8:	85 c0                	test   %eax,%eax
801079ca:	74 4e                	je     80107a1a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801079cc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801079d1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801079d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801079db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079e1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079e4:	01 d9                	add    %ebx,%ecx
801079e6:	05 00 00 00 80       	add    $0x80000000,%eax
801079eb:	57                   	push   %edi
801079ec:	51                   	push   %ecx
801079ed:	50                   	push   %eax
801079ee:	ff 75 10             	pushl  0x10(%ebp)
801079f1:	e8 6a 9f ff ff       	call   80101960 <readi>
801079f6:	83 c4 10             	add    $0x10,%esp
801079f9:	39 f8                	cmp    %edi,%eax
801079fb:	74 ab                	je     801079a8 <loaduvm+0x28>
}
801079fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a05:	5b                   	pop    %ebx
80107a06:	5e                   	pop    %esi
80107a07:	5f                   	pop    %edi
80107a08:	5d                   	pop    %ebp
80107a09:	c3                   	ret    
80107a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a13:	31 c0                	xor    %eax,%eax
}
80107a15:	5b                   	pop    %ebx
80107a16:	5e                   	pop    %esi
80107a17:	5f                   	pop    %edi
80107a18:	5d                   	pop    %ebp
80107a19:	c3                   	ret    
      panic("loaduvm: address should exist");
80107a1a:	83 ec 0c             	sub    $0xc,%esp
80107a1d:	68 df 88 10 80       	push   $0x801088df
80107a22:	e8 69 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107a27:	83 ec 0c             	sub    $0xc,%esp
80107a2a:	68 80 89 10 80       	push   $0x80108980
80107a2f:	e8 5c 89 ff ff       	call   80100390 <panic>
80107a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a40 <allocuvm>:
{
80107a40:	55                   	push   %ebp
80107a41:	89 e5                	mov    %esp,%ebp
80107a43:	57                   	push   %edi
80107a44:	56                   	push   %esi
80107a45:	53                   	push   %ebx
80107a46:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107a49:	8b 7d 10             	mov    0x10(%ebp),%edi
80107a4c:	85 ff                	test   %edi,%edi
80107a4e:	0f 88 8e 00 00 00    	js     80107ae2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107a54:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107a57:	0f 82 93 00 00 00    	jb     80107af0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a60:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107a66:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107a6c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107a6f:	0f 86 7e 00 00 00    	jbe    80107af3 <allocuvm+0xb3>
80107a75:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107a78:	8b 7d 08             	mov    0x8(%ebp),%edi
80107a7b:	eb 42                	jmp    80107abf <allocuvm+0x7f>
80107a7d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107a80:	83 ec 04             	sub    $0x4,%esp
80107a83:	68 00 10 00 00       	push   $0x1000
80107a88:	6a 00                	push   $0x0
80107a8a:	50                   	push   %eax
80107a8b:	e8 d0 d7 ff ff       	call   80105260 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107a90:	58                   	pop    %eax
80107a91:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107a97:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a9c:	5a                   	pop    %edx
80107a9d:	6a 06                	push   $0x6
80107a9f:	50                   	push   %eax
80107aa0:	89 da                	mov    %ebx,%edx
80107aa2:	89 f8                	mov    %edi,%eax
80107aa4:	e8 67 fb ff ff       	call   80107610 <mappages>
80107aa9:	83 c4 10             	add    $0x10,%esp
80107aac:	85 c0                	test   %eax,%eax
80107aae:	78 50                	js     80107b00 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107ab0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ab6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107ab9:	0f 86 81 00 00 00    	jbe    80107b40 <allocuvm+0x100>
    mem = kalloc();
80107abf:	e8 fc a9 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80107ac4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107ac6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107ac8:	75 b6                	jne    80107a80 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107aca:	83 ec 0c             	sub    $0xc,%esp
80107acd:	68 fd 88 10 80       	push   $0x801088fd
80107ad2:	e8 89 8b ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107ad7:	83 c4 10             	add    $0x10,%esp
80107ada:	8b 45 0c             	mov    0xc(%ebp),%eax
80107add:	39 45 10             	cmp    %eax,0x10(%ebp)
80107ae0:	77 6e                	ja     80107b50 <allocuvm+0x110>
}
80107ae2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107ae5:	31 ff                	xor    %edi,%edi
}
80107ae7:	89 f8                	mov    %edi,%eax
80107ae9:	5b                   	pop    %ebx
80107aea:	5e                   	pop    %esi
80107aeb:	5f                   	pop    %edi
80107aec:	5d                   	pop    %ebp
80107aed:	c3                   	ret    
80107aee:	66 90                	xchg   %ax,%ax
    return oldsz;
80107af0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107af3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107af6:	89 f8                	mov    %edi,%eax
80107af8:	5b                   	pop    %ebx
80107af9:	5e                   	pop    %esi
80107afa:	5f                   	pop    %edi
80107afb:	5d                   	pop    %ebp
80107afc:	c3                   	ret    
80107afd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107b00:	83 ec 0c             	sub    $0xc,%esp
80107b03:	68 15 89 10 80       	push   $0x80108915
80107b08:	e8 53 8b ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107b0d:	83 c4 10             	add    $0x10,%esp
80107b10:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b13:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b16:	76 0d                	jbe    80107b25 <allocuvm+0xe5>
80107b18:	89 c1                	mov    %eax,%ecx
80107b1a:	8b 55 10             	mov    0x10(%ebp),%edx
80107b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b20:	e8 7b fb ff ff       	call   801076a0 <deallocuvm.part.0>
      kfree(mem);
80107b25:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107b28:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107b2a:	56                   	push   %esi
80107b2b:	e8 e0 a7 ff ff       	call   80102310 <kfree>
      return 0;
80107b30:	83 c4 10             	add    $0x10,%esp
}
80107b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b36:	89 f8                	mov    %edi,%eax
80107b38:	5b                   	pop    %ebx
80107b39:	5e                   	pop    %esi
80107b3a:	5f                   	pop    %edi
80107b3b:	5d                   	pop    %ebp
80107b3c:	c3                   	ret    
80107b3d:	8d 76 00             	lea    0x0(%esi),%esi
80107b40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107b43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b46:	5b                   	pop    %ebx
80107b47:	89 f8                	mov    %edi,%eax
80107b49:	5e                   	pop    %esi
80107b4a:	5f                   	pop    %edi
80107b4b:	5d                   	pop    %ebp
80107b4c:	c3                   	ret    
80107b4d:	8d 76 00             	lea    0x0(%esi),%esi
80107b50:	89 c1                	mov    %eax,%ecx
80107b52:	8b 55 10             	mov    0x10(%ebp),%edx
80107b55:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107b58:	31 ff                	xor    %edi,%edi
80107b5a:	e8 41 fb ff ff       	call   801076a0 <deallocuvm.part.0>
80107b5f:	eb 92                	jmp    80107af3 <allocuvm+0xb3>
80107b61:	eb 0d                	jmp    80107b70 <deallocuvm>
80107b63:	90                   	nop
80107b64:	90                   	nop
80107b65:	90                   	nop
80107b66:	90                   	nop
80107b67:	90                   	nop
80107b68:	90                   	nop
80107b69:	90                   	nop
80107b6a:	90                   	nop
80107b6b:	90                   	nop
80107b6c:	90                   	nop
80107b6d:	90                   	nop
80107b6e:	90                   	nop
80107b6f:	90                   	nop

80107b70 <deallocuvm>:
{
80107b70:	55                   	push   %ebp
80107b71:	89 e5                	mov    %esp,%ebp
80107b73:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107b79:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107b7c:	39 d1                	cmp    %edx,%ecx
80107b7e:	73 10                	jae    80107b90 <deallocuvm+0x20>
}
80107b80:	5d                   	pop    %ebp
80107b81:	e9 1a fb ff ff       	jmp    801076a0 <deallocuvm.part.0>
80107b86:	8d 76 00             	lea    0x0(%esi),%esi
80107b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107b90:	89 d0                	mov    %edx,%eax
80107b92:	5d                   	pop    %ebp
80107b93:	c3                   	ret    
80107b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107ba0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	57                   	push   %edi
80107ba4:	56                   	push   %esi
80107ba5:	53                   	push   %ebx
80107ba6:	83 ec 0c             	sub    $0xc,%esp
80107ba9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107bac:	85 f6                	test   %esi,%esi
80107bae:	74 59                	je     80107c09 <freevm+0x69>
80107bb0:	31 c9                	xor    %ecx,%ecx
80107bb2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107bb7:	89 f0                	mov    %esi,%eax
80107bb9:	e8 e2 fa ff ff       	call   801076a0 <deallocuvm.part.0>
80107bbe:	89 f3                	mov    %esi,%ebx
80107bc0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107bc6:	eb 0f                	jmp    80107bd7 <freevm+0x37>
80107bc8:	90                   	nop
80107bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bd0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107bd3:	39 fb                	cmp    %edi,%ebx
80107bd5:	74 23                	je     80107bfa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107bd7:	8b 03                	mov    (%ebx),%eax
80107bd9:	a8 01                	test   $0x1,%al
80107bdb:	74 f3                	je     80107bd0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107bdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107be2:	83 ec 0c             	sub    $0xc,%esp
80107be5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107be8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107bed:	50                   	push   %eax
80107bee:	e8 1d a7 ff ff       	call   80102310 <kfree>
80107bf3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107bf6:	39 fb                	cmp    %edi,%ebx
80107bf8:	75 dd                	jne    80107bd7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107bfa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c00:	5b                   	pop    %ebx
80107c01:	5e                   	pop    %esi
80107c02:	5f                   	pop    %edi
80107c03:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107c04:	e9 07 a7 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107c09:	83 ec 0c             	sub    $0xc,%esp
80107c0c:	68 31 89 10 80       	push   $0x80108931
80107c11:	e8 7a 87 ff ff       	call   80100390 <panic>
80107c16:	8d 76 00             	lea    0x0(%esi),%esi
80107c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c20 <setupkvm>:
{
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
80107c23:	56                   	push   %esi
80107c24:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107c25:	e8 96 a8 ff ff       	call   801024c0 <kalloc>
80107c2a:	85 c0                	test   %eax,%eax
80107c2c:	89 c6                	mov    %eax,%esi
80107c2e:	74 42                	je     80107c72 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107c30:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c33:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107c38:	68 00 10 00 00       	push   $0x1000
80107c3d:	6a 00                	push   $0x0
80107c3f:	50                   	push   %eax
80107c40:	e8 1b d6 ff ff       	call   80105260 <memset>
80107c45:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107c48:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107c4b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107c4e:	83 ec 08             	sub    $0x8,%esp
80107c51:	8b 13                	mov    (%ebx),%edx
80107c53:	ff 73 0c             	pushl  0xc(%ebx)
80107c56:	50                   	push   %eax
80107c57:	29 c1                	sub    %eax,%ecx
80107c59:	89 f0                	mov    %esi,%eax
80107c5b:	e8 b0 f9 ff ff       	call   80107610 <mappages>
80107c60:	83 c4 10             	add    $0x10,%esp
80107c63:	85 c0                	test   %eax,%eax
80107c65:	78 19                	js     80107c80 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c67:	83 c3 10             	add    $0x10,%ebx
80107c6a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107c70:	75 d6                	jne    80107c48 <setupkvm+0x28>
}
80107c72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c75:	89 f0                	mov    %esi,%eax
80107c77:	5b                   	pop    %ebx
80107c78:	5e                   	pop    %esi
80107c79:	5d                   	pop    %ebp
80107c7a:	c3                   	ret    
80107c7b:	90                   	nop
80107c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107c80:	83 ec 0c             	sub    $0xc,%esp
80107c83:	56                   	push   %esi
      return 0;
80107c84:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107c86:	e8 15 ff ff ff       	call   80107ba0 <freevm>
      return 0;
80107c8b:	83 c4 10             	add    $0x10,%esp
}
80107c8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c91:	89 f0                	mov    %esi,%eax
80107c93:	5b                   	pop    %ebx
80107c94:	5e                   	pop    %esi
80107c95:	5d                   	pop    %ebp
80107c96:	c3                   	ret    
80107c97:	89 f6                	mov    %esi,%esi
80107c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ca0 <kvmalloc>:
{
80107ca0:	55                   	push   %ebp
80107ca1:	89 e5                	mov    %esp,%ebp
80107ca3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ca6:	e8 75 ff ff ff       	call   80107c20 <setupkvm>
80107cab:	a3 04 74 11 80       	mov    %eax,0x80117404
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107cb0:	05 00 00 00 80       	add    $0x80000000,%eax
80107cb5:	0f 22 d8             	mov    %eax,%cr3
}
80107cb8:	c9                   	leave  
80107cb9:	c3                   	ret    
80107cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107cc0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107cc0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107cc1:	31 c9                	xor    %ecx,%ecx
{
80107cc3:	89 e5                	mov    %esp,%ebp
80107cc5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80107cce:	e8 bd f8 ff ff       	call   80107590 <walkpgdir>
  if(pte == 0)
80107cd3:	85 c0                	test   %eax,%eax
80107cd5:	74 05                	je     80107cdc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107cd7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107cda:	c9                   	leave  
80107cdb:	c3                   	ret    
    panic("clearpteu");
80107cdc:	83 ec 0c             	sub    $0xc,%esp
80107cdf:	68 42 89 10 80       	push   $0x80108942
80107ce4:	e8 a7 86 ff ff       	call   80100390 <panic>
80107ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107cf0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107cf0:	55                   	push   %ebp
80107cf1:	89 e5                	mov    %esp,%ebp
80107cf3:	57                   	push   %edi
80107cf4:	56                   	push   %esi
80107cf5:	53                   	push   %ebx
80107cf6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107cf9:	e8 22 ff ff ff       	call   80107c20 <setupkvm>
80107cfe:	85 c0                	test   %eax,%eax
80107d00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d03:	0f 84 9f 00 00 00    	je     80107da8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107d09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107d0c:	85 c9                	test   %ecx,%ecx
80107d0e:	0f 84 94 00 00 00    	je     80107da8 <copyuvm+0xb8>
80107d14:	31 ff                	xor    %edi,%edi
80107d16:	eb 4a                	jmp    80107d62 <copyuvm+0x72>
80107d18:	90                   	nop
80107d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107d20:	83 ec 04             	sub    $0x4,%esp
80107d23:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107d29:	68 00 10 00 00       	push   $0x1000
80107d2e:	53                   	push   %ebx
80107d2f:	50                   	push   %eax
80107d30:	e8 db d5 ff ff       	call   80105310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107d35:	58                   	pop    %eax
80107d36:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107d3c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d41:	5a                   	pop    %edx
80107d42:	ff 75 e4             	pushl  -0x1c(%ebp)
80107d45:	50                   	push   %eax
80107d46:	89 fa                	mov    %edi,%edx
80107d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d4b:	e8 c0 f8 ff ff       	call   80107610 <mappages>
80107d50:	83 c4 10             	add    $0x10,%esp
80107d53:	85 c0                	test   %eax,%eax
80107d55:	78 61                	js     80107db8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107d57:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107d5d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107d60:	76 46                	jbe    80107da8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107d62:	8b 45 08             	mov    0x8(%ebp),%eax
80107d65:	31 c9                	xor    %ecx,%ecx
80107d67:	89 fa                	mov    %edi,%edx
80107d69:	e8 22 f8 ff ff       	call   80107590 <walkpgdir>
80107d6e:	85 c0                	test   %eax,%eax
80107d70:	74 61                	je     80107dd3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107d72:	8b 00                	mov    (%eax),%eax
80107d74:	a8 01                	test   $0x1,%al
80107d76:	74 4e                	je     80107dc6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107d78:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107d7a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107d7f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107d88:	e8 33 a7 ff ff       	call   801024c0 <kalloc>
80107d8d:	85 c0                	test   %eax,%eax
80107d8f:	89 c6                	mov    %eax,%esi
80107d91:	75 8d                	jne    80107d20 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107d93:	83 ec 0c             	sub    $0xc,%esp
80107d96:	ff 75 e0             	pushl  -0x20(%ebp)
80107d99:	e8 02 fe ff ff       	call   80107ba0 <freevm>
  return 0;
80107d9e:	83 c4 10             	add    $0x10,%esp
80107da1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dae:	5b                   	pop    %ebx
80107daf:	5e                   	pop    %esi
80107db0:	5f                   	pop    %edi
80107db1:	5d                   	pop    %ebp
80107db2:	c3                   	ret    
80107db3:	90                   	nop
80107db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107db8:	83 ec 0c             	sub    $0xc,%esp
80107dbb:	56                   	push   %esi
80107dbc:	e8 4f a5 ff ff       	call   80102310 <kfree>
      goto bad;
80107dc1:	83 c4 10             	add    $0x10,%esp
80107dc4:	eb cd                	jmp    80107d93 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107dc6:	83 ec 0c             	sub    $0xc,%esp
80107dc9:	68 66 89 10 80       	push   $0x80108966
80107dce:	e8 bd 85 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107dd3:	83 ec 0c             	sub    $0xc,%esp
80107dd6:	68 4c 89 10 80       	push   $0x8010894c
80107ddb:	e8 b0 85 ff ff       	call   80100390 <panic>

80107de0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107de0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107de1:	31 c9                	xor    %ecx,%ecx
{
80107de3:	89 e5                	mov    %esp,%ebp
80107de5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107de8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107deb:	8b 45 08             	mov    0x8(%ebp),%eax
80107dee:	e8 9d f7 ff ff       	call   80107590 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107df3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107df5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107df6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107df8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107dfd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107e00:	05 00 00 00 80       	add    $0x80000000,%eax
80107e05:	83 fa 05             	cmp    $0x5,%edx
80107e08:	ba 00 00 00 00       	mov    $0x0,%edx
80107e0d:	0f 45 c2             	cmovne %edx,%eax
}
80107e10:	c3                   	ret    
80107e11:	eb 0d                	jmp    80107e20 <copyout>
80107e13:	90                   	nop
80107e14:	90                   	nop
80107e15:	90                   	nop
80107e16:	90                   	nop
80107e17:	90                   	nop
80107e18:	90                   	nop
80107e19:	90                   	nop
80107e1a:	90                   	nop
80107e1b:	90                   	nop
80107e1c:	90                   	nop
80107e1d:	90                   	nop
80107e1e:	90                   	nop
80107e1f:	90                   	nop

80107e20 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107e20:	55                   	push   %ebp
80107e21:	89 e5                	mov    %esp,%ebp
80107e23:	57                   	push   %edi
80107e24:	56                   	push   %esi
80107e25:	53                   	push   %ebx
80107e26:	83 ec 1c             	sub    $0x1c,%esp
80107e29:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107e32:	85 db                	test   %ebx,%ebx
80107e34:	75 40                	jne    80107e76 <copyout+0x56>
80107e36:	eb 70                	jmp    80107ea8 <copyout+0x88>
80107e38:	90                   	nop
80107e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107e40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107e43:	89 f1                	mov    %esi,%ecx
80107e45:	29 d1                	sub    %edx,%ecx
80107e47:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107e4d:	39 d9                	cmp    %ebx,%ecx
80107e4f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107e52:	29 f2                	sub    %esi,%edx
80107e54:	83 ec 04             	sub    $0x4,%esp
80107e57:	01 d0                	add    %edx,%eax
80107e59:	51                   	push   %ecx
80107e5a:	57                   	push   %edi
80107e5b:	50                   	push   %eax
80107e5c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107e5f:	e8 ac d4 ff ff       	call   80105310 <memmove>
    len -= n;
    buf += n;
80107e64:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107e67:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107e6a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107e70:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107e72:	29 cb                	sub    %ecx,%ebx
80107e74:	74 32                	je     80107ea8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107e76:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107e78:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107e7b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107e7e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107e84:	56                   	push   %esi
80107e85:	ff 75 08             	pushl  0x8(%ebp)
80107e88:	e8 53 ff ff ff       	call   80107de0 <uva2ka>
    if(pa0 == 0)
80107e8d:	83 c4 10             	add    $0x10,%esp
80107e90:	85 c0                	test   %eax,%eax
80107e92:	75 ac                	jne    80107e40 <copyout+0x20>
  }
  return 0;
}
80107e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e9c:	5b                   	pop    %ebx
80107e9d:	5e                   	pop    %esi
80107e9e:	5f                   	pop    %edi
80107e9f:	5d                   	pop    %ebp
80107ea0:	c3                   	ret    
80107ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107eab:	31 c0                	xor    %eax,%eax
}
80107ead:	5b                   	pop    %ebx
80107eae:	5e                   	pop    %esi
80107eaf:	5f                   	pop    %edi
80107eb0:	5d                   	pop    %ebp
80107eb1:	c3                   	ret    
