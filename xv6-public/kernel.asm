
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
80100028:	bc e0 c5 10 80       	mov    $0x8010c5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 2f 10 80       	mov    $0x80102f80,%eax
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
8010004c:	68 40 84 10 80       	push   $0x80108440
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 65 46 00 00       	call   801046c0 <initlock>
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
80100092:	68 47 84 10 80       	push   $0x80108447
80100097:	50                   	push   %eax
80100098:	e8 f3 44 00 00       	call   80104590 <initsleeplock>
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
801000e4:	e8 17 47 00 00       	call   80104800 <acquire>
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
80100162:	e8 59 47 00 00       	call   801048c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 44 00 00       	call   801045d0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 7d 20 00 00       	call   80102200 <iderw>
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
80100193:	68 4e 84 10 80       	push   $0x8010844e
80100198:	e8 e3 01 00 00       	call   80100380 <panic>
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
801001ae:	e8 bd 44 00 00       	call   80104670 <holdingsleep>
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
801001c4:	e9 37 20 00 00       	jmp    80102200 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 84 10 80       	push   $0x8010845f
801001d1:	e8 aa 01 00 00       	call   80100380 <panic>
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
801001ef:	e8 7c 44 00 00       	call   80104670 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 44 00 00       	call   80104630 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 f0 45 00 00       	call   80104800 <acquire>
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
8010025c:	e9 5f 46 00 00       	jmp    801048c0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 84 10 80       	push   $0x80108466
80100269:	e8 12 01 00 00       	call   80100380 <panic>
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
80100279:	8b 75 08             	mov    0x8(%ebp),%esi
8010027c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010027f:	56                   	push   %esi
80100280:	e8 bb 15 00 00       	call   80101840 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010028c:	e8 6f 45 00 00       	call   80104800 <acquire>
  while(n > 0){
80100291:	83 c4 10             	add    $0x10,%esp
80100294:	31 c0                	xor    %eax,%eax
80100296:	85 db                	test   %ebx,%ebx
80100298:	0f 8e a7 00 00 00    	jle    80100345 <consoleread+0xd5>
8010029e:	89 df                	mov    %ebx,%edi
    while(input.r == input.w){
801002a0:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a6:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
801002ac:	74 31                	je     801002df <consoleread+0x6f>
801002ae:	eb 60                	jmp    80100310 <consoleread+0xa0>
//      if(myproc()->killed){
      if(myproc()->killed || myproc()->exited){
801002b0:	e8 db 35 00 00       	call   80103890 <myproc>
801002b5:	8b 40 18             	mov    0x18(%eax),%eax
801002b8:	85 c0                	test   %eax,%eax
801002ba:	75 2f                	jne    801002eb <consoleread+0x7b>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002bc:	83 ec 08             	sub    $0x8,%esp
801002bf:	68 40 b5 10 80       	push   $0x8010b540
801002c4:	68 c0 0f 11 80       	push   $0x80110fc0
801002c9:	e8 32 3a 00 00       	call   80103d00 <sleep>
    while(input.r == input.w){
801002ce:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d4:	83 c4 10             	add    $0x10,%esp
801002d7:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002dd:	75 31                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed || myproc()->exited){
801002df:	e8 ac 35 00 00       	call   80103890 <myproc>
801002e4:	8b 50 14             	mov    0x14(%eax),%edx
801002e7:	85 d2                	test   %edx,%edx
801002e9:	74 c5                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002eb:	83 ec 0c             	sub    $0xc,%esp
801002ee:	68 40 b5 10 80       	push   $0x8010b540
801002f3:	e8 c8 45 00 00       	call   801048c0 <release>
        ilock(ip);
801002f8:	89 34 24             	mov    %esi,(%esp)
801002fb:	e8 60 14 00 00       	call   80101760 <ilock>
        return -1;
80100300:	83 c4 10             	add    $0x10,%esp
80100303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100308:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010030b:	5b                   	pop    %ebx
8010030c:	5e                   	pop    %esi
8010030d:	5f                   	pop    %edi
8010030e:	5d                   	pop    %ebp
8010030f:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3c                	je     80100365 <consoleread+0xf5>
    *dst++ = c;
80100329:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
8010032d:	83 ef 01             	sub    $0x1,%edi
    if(c == '\n')
80100330:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100333:	8b 55 0c             	mov    0xc(%ebp),%edx
80100336:	88 42 ff             	mov    %al,-0x1(%edx)
    if(c == '\n')
80100339:	74 3a                	je     80100375 <consoleread+0x105>
  while(n > 0){
8010033b:	85 ff                	test   %edi,%edi
8010033d:	0f 85 5d ff ff ff    	jne    801002a0 <consoleread+0x30>
80100343:	89 d8                	mov    %ebx,%eax
  release(&cons.lock);
80100345:	83 ec 0c             	sub    $0xc,%esp
80100348:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010034b:	68 40 b5 10 80       	push   $0x8010b540
80100350:	e8 6b 45 00 00       	call   801048c0 <release>
  ilock(ip);
80100355:	89 34 24             	mov    %esi,(%esp)
80100358:	e8 03 14 00 00       	call   80101760 <ilock>
  return target - n;
8010035d:	83 c4 10             	add    $0x10,%esp
80100360:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100363:	eb a3                	jmp    80100308 <consoleread+0x98>
80100365:	89 d8                	mov    %ebx,%eax
80100367:	29 f8                	sub    %edi,%eax
      if(n < target){
80100369:	39 df                	cmp    %ebx,%edi
8010036b:	73 d8                	jae    80100345 <consoleread+0xd5>
        input.r--;
8010036d:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100373:	eb d0                	jmp    80100345 <consoleread+0xd5>
80100375:	89 d8                	mov    %ebx,%eax
80100377:	29 f8                	sub    %edi,%eax
80100379:	eb ca                	jmp    80100345 <consoleread+0xd5>
8010037b:	90                   	nop
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 72 24 00 00       	call   80102810 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 84 10 80       	push   $0x8010846d
801003a7:	e8 a4 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	pushl  0x8(%ebp)
801003b0:	e8 9b 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 af 8d 10 80 	movl   $0x80108daf,(%esp)
801003bc:	e8 8f 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	5a                   	pop    %edx
801003c2:	8d 45 08             	lea    0x8(%ebp),%eax
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 13 43 00 00       	call   801046e0 <getcallerpcs>
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	pushl  (%ebx)
801003d5:	83 c3 04             	add    $0x4,%ebx
801003d8:	68 81 84 10 80       	push   $0x80108481
801003dd:	e8 6e 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
801003f0:	00 00 00 
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100400 <consputc>:
  if(panicked){
80100400:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100406:	85 c9                	test   %ecx,%ecx
80100408:	74 06                	je     80100410 <consputc+0x10>
8010040a:	fa                   	cli    
8010040b:	eb fe                	jmp    8010040b <consputc+0xb>
8010040d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c6                	mov    %eax,%esi
80100418:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 b1 00 00 00    	je     801004d7 <consputc+0xd7>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 71 5f 00 00       	call   801063a0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 da                	mov    %ebx,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 da                	mov    %ebx,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c7                	mov    %eax,%edi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
8010045a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010045d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010045f:	83 fe 0a             	cmp    $0xa,%esi
80100462:	0f 84 f3 00 00 00    	je     8010055b <consputc+0x15b>
  else if(c == BACKSPACE){
80100468:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010046e:	0f 84 d7 00 00 00    	je     8010054b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100474:	89 f0                	mov    %esi,%eax
80100476:	0f b6 c0             	movzbl %al,%eax
80100479:	80 cc 07             	or     $0x7,%ah
8010047c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100483:	80 
80100484:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100487:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010048d:	0f 8f ab 00 00 00    	jg     8010053e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
80100493:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100499:	7f 66                	jg     80100501 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010049b:	be d4 03 00 00       	mov    $0x3d4,%esi
801004a0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a5:	89 f2                	mov    %esi,%edx
801004a7:	ee                   	out    %al,(%dx)
801004a8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004ad:	89 d8                	mov    %ebx,%eax
801004af:	c1 f8 08             	sar    $0x8,%eax
801004b2:	89 ca                	mov    %ecx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ba:	89 f2                	mov    %esi,%edx
801004bc:	ee                   	out    %al,(%dx)
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	89 ca                	mov    %ecx,%edx
801004c1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004c2:	b8 20 07 00 00       	mov    $0x720,%eax
801004c7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004ce:	80 
}
801004cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d2:	5b                   	pop    %ebx
801004d3:	5e                   	pop    %esi
801004d4:	5f                   	pop    %edi
801004d5:	5d                   	pop    %ebp
801004d6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004d7:	83 ec 0c             	sub    $0xc,%esp
801004da:	6a 08                	push   $0x8
801004dc:	e8 bf 5e 00 00       	call   801063a0 <uartputc>
801004e1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004e8:	e8 b3 5e 00 00       	call   801063a0 <uartputc>
801004ed:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004f4:	e8 a7 5e 00 00       	call   801063a0 <uartputc>
801004f9:	83 c4 10             	add    $0x10,%esp
801004fc:	e9 31 ff ff ff       	jmp    80100432 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100501:	52                   	push   %edx
80100502:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100507:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010050a:	68 a0 80 0b 80       	push   $0x800b80a0
8010050f:	68 00 80 0b 80       	push   $0x800b8000
80100514:	e8 a7 44 00 00       	call   801049c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100529:	6a 00                	push   $0x0
8010052b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100530:	50                   	push   %eax
80100531:	e8 da 43 00 00       	call   80104910 <memset>
80100536:	83 c4 10             	add    $0x10,%esp
80100539:	e9 5d ff ff ff       	jmp    8010049b <consputc+0x9b>
    panic("pos under/overflow");
8010053e:	83 ec 0c             	sub    $0xc,%esp
80100541:	68 85 84 10 80       	push   $0x80108485
80100546:	e8 35 fe ff ff       	call   80100380 <panic>
    if(pos > 0) --pos;
8010054b:	85 db                	test   %ebx,%ebx
8010054d:	0f 84 48 ff ff ff    	je     8010049b <consputc+0x9b>
80100553:	83 eb 01             	sub    $0x1,%ebx
80100556:	e9 2c ff ff ff       	jmp    80100487 <consputc+0x87>
    pos += 80 - pos%80;
8010055b:	89 d8                	mov    %ebx,%eax
8010055d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100562:	99                   	cltd   
80100563:	f7 f9                	idiv   %ecx
80100565:	29 d1                	sub    %edx,%ecx
80100567:	01 cb                	add    %ecx,%ebx
80100569:	e9 19 ff ff ff       	jmp    80100487 <consputc+0x87>
8010056e:	66 90                	xchg   %ax,%ax

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	53                   	push   %ebx
80100576:	89 d3                	mov    %edx,%ebx
80100578:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
{
8010057d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100580:	74 04                	je     80100586 <printint+0x16>
80100582:	85 c0                	test   %eax,%eax
80100584:	78 5a                	js     801005e0 <printint+0x70>
    x = xx;
80100586:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010058d:	31 c9                	xor    %ecx,%ecx
8010058f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100592:	eb 06                	jmp    8010059a <printint+0x2a>
80100594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100598:	89 f9                	mov    %edi,%ecx
8010059a:	31 d2                	xor    %edx,%edx
8010059c:	8d 79 01             	lea    0x1(%ecx),%edi
8010059f:	f7 f3                	div    %ebx
801005a1:	0f b6 92 b0 84 10 80 	movzbl -0x7fef7b50(%edx),%edx
  }while((x /= base) != 0);
801005a8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005aa:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005ad:	75 e9                	jne    80100598 <printint+0x28>
  if(sign)
801005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005b2:	85 c0                	test   %eax,%eax
801005b4:	74 08                	je     801005be <printint+0x4e>
    buf[i++] = '-';
801005b6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005bb:	8d 79 02             	lea    0x2(%ecx),%edi
801005be:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005c8:	0f be 03             	movsbl (%ebx),%eax
801005cb:	83 eb 01             	sub    $0x1,%ebx
801005ce:	e8 2d fe ff ff       	call   80100400 <consputc>
  while(--i >= 0)
801005d3:	39 f3                	cmp    %esi,%ebx
801005d5:	75 f1                	jne    801005c8 <printint+0x58>
}
801005d7:	83 c4 2c             	add    $0x2c,%esp
801005da:	5b                   	pop    %ebx
801005db:	5e                   	pop    %esi
801005dc:	5f                   	pop    %edi
801005dd:	5d                   	pop    %ebp
801005de:	c3                   	ret    
801005df:	90                   	nop
    x = -xx;
801005e0:	f7 d8                	neg    %eax
801005e2:	eb a9                	jmp    8010058d <printint+0x1d>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 18             	sub    $0x18,%esp
801005f9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005fc:	ff 75 08             	pushl  0x8(%ebp)
801005ff:	e8 3c 12 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100604:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010060b:	e8 f0 41 00 00       	call   80104800 <acquire>
  for(i = 0; i < n; i++)
80100610:	83 c4 10             	add    $0x10,%esp
80100613:	85 f6                	test   %esi,%esi
80100615:	7e 18                	jle    8010062f <consolewrite+0x3f>
80100617:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010061a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 d5 fd ff ff       	call   80100400 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 fb                	cmp    %edi,%ebx
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	83 ec 0c             	sub    $0xc,%esp
80100632:	68 40 b5 10 80       	push   $0x8010b540
80100637:	e8 84 42 00 00       	call   801048c0 <release>
  ilock(ip);
8010063c:	58                   	pop    %eax
8010063d:	ff 75 08             	pushl  0x8(%ebp)
80100640:	e8 1b 11 00 00       	call   80101760 <ilock>

  return n;
}
80100645:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100648:	89 f0                	mov    %esi,%eax
8010064a:	5b                   	pop    %ebx
8010064b:	5e                   	pop    %esi
8010064c:	5f                   	pop    %edi
8010064d:	5d                   	pop    %ebp
8010064e:	c3                   	ret    
8010064f:	90                   	nop

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 74 b5 10 80       	mov    0x8010b574,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100663:	0f 85 6f 01 00 00    	jne    801007d8 <cprintf+0x188>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c7                	mov    %eax,%edi
80100670:	0f 84 77 01 00 00    	je     801007ed <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100679:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010067c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010067e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100681:	85 c0                	test   %eax,%eax
80100683:	75 56                	jne    801006db <cprintf+0x8b>
80100685:	eb 79                	jmp    80100700 <cprintf+0xb0>
80100687:	89 f6                	mov    %esi,%esi
80100689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100690:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100693:	85 d2                	test   %edx,%edx
80100695:	74 69                	je     80100700 <cprintf+0xb0>
80100697:	83 c3 02             	add    $0x2,%ebx
    switch(c){
8010069a:	83 fa 70             	cmp    $0x70,%edx
8010069d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006a0:	0f 84 84 00 00 00    	je     8010072a <cprintf+0xda>
801006a6:	7f 78                	jg     80100720 <cprintf+0xd0>
801006a8:	83 fa 25             	cmp    $0x25,%edx
801006ab:	0f 84 ff 00 00 00    	je     801007b0 <cprintf+0x160>
801006b1:	83 fa 64             	cmp    $0x64,%edx
801006b4:	0f 85 8e 00 00 00    	jne    80100748 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006bd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006c2:	8d 48 04             	lea    0x4(%eax),%ecx
801006c5:	8b 00                	mov    (%eax),%eax
801006c7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006ca:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cf:	e8 9c fe ff ff       	call   80100570 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d4:	0f b6 06             	movzbl (%esi),%eax
801006d7:	85 c0                	test   %eax,%eax
801006d9:	74 25                	je     80100700 <cprintf+0xb0>
801006db:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006de:	83 f8 25             	cmp    $0x25,%eax
801006e1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006e4:	74 aa                	je     80100690 <cprintf+0x40>
801006e6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006e9:	e8 12 fd ff ff       	call   80100400 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ee:	0f b6 06             	movzbl (%esi),%eax
      continue;
801006f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801006f4:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f6:	85 c0                	test   %eax,%eax
801006f8:	75 e1                	jne    801006db <cprintf+0x8b>
801006fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100700:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100703:	85 c0                	test   %eax,%eax
80100705:	74 10                	je     80100717 <cprintf+0xc7>
    release(&cons.lock);
80100707:	83 ec 0c             	sub    $0xc,%esp
8010070a:	68 40 b5 10 80       	push   $0x8010b540
8010070f:	e8 ac 41 00 00       	call   801048c0 <release>
80100714:	83 c4 10             	add    $0x10,%esp
}
80100717:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071a:	5b                   	pop    %ebx
8010071b:	5e                   	pop    %esi
8010071c:	5f                   	pop    %edi
8010071d:	5d                   	pop    %ebp
8010071e:	c3                   	ret    
8010071f:	90                   	nop
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 43                	je     80100768 <cprintf+0x118>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010072a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072d:	ba 10 00 00 00       	mov    $0x10,%edx
80100732:	8d 48 04             	lea    0x4(%eax),%ecx
80100735:	8b 00                	mov    (%eax),%eax
80100737:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010073a:	31 c9                	xor    %ecx,%ecx
8010073c:	e8 2f fe ff ff       	call   80100570 <printint>
      break;
80100741:	eb 91                	jmp    801006d4 <cprintf+0x84>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100750:	e8 ab fc ff ff       	call   80100400 <consputc>
      consputc(c);
80100755:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 a1 fc ff ff       	call   80100400 <consputc>
      break;
8010075f:	e9 70 ff ff ff       	jmp    801006d4 <cprintf+0x84>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010076b:	8b 10                	mov    (%eax),%edx
8010076d:	8d 48 04             	lea    0x4(%eax),%ecx
80100770:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100773:	85 d2                	test   %edx,%edx
80100775:	74 49                	je     801007c0 <cprintf+0x170>
      for(; *s; s++)
80100777:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010077a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010077d:	84 c0                	test   %al,%al
8010077f:	0f 84 4f ff ff ff    	je     801006d4 <cprintf+0x84>
80100785:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100788:	89 d3                	mov    %edx,%ebx
8010078a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100790:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100793:	e8 68 fc ff ff       	call   80100400 <consputc>
      for(; *s; s++)
80100798:	0f be 03             	movsbl (%ebx),%eax
8010079b:	84 c0                	test   %al,%al
8010079d:	75 f1                	jne    80100790 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
8010079f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007a2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007a8:	e9 27 ff ff ff       	jmp    801006d4 <cprintf+0x84>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007b0:	b8 25 00 00 00       	mov    $0x25,%eax
801007b5:	e8 46 fc ff ff       	call   80100400 <consputc>
      break;
801007ba:	e9 15 ff ff ff       	jmp    801006d4 <cprintf+0x84>
801007bf:	90                   	nop
        s = "(null)";
801007c0:	ba 98 84 10 80       	mov    $0x80108498,%edx
      for(; *s; s++)
801007c5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007c8:	b8 28 00 00 00       	mov    $0x28,%eax
801007cd:	89 d3                	mov    %edx,%ebx
801007cf:	eb bf                	jmp    80100790 <cprintf+0x140>
801007d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d8:	83 ec 0c             	sub    $0xc,%esp
801007db:	68 40 b5 10 80       	push   $0x8010b540
801007e0:	e8 1b 40 00 00       	call   80104800 <acquire>
801007e5:	83 c4 10             	add    $0x10,%esp
801007e8:	e9 7c fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007ed:	83 ec 0c             	sub    $0xc,%esp
801007f0:	68 9f 84 10 80       	push   $0x8010849f
801007f5:	e8 86 fb ff ff       	call   80100380 <panic>
801007fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100800 <consoleintr>:
{
80100800:	55                   	push   %ebp
80100801:	89 e5                	mov    %esp,%ebp
80100803:	57                   	push   %edi
80100804:	56                   	push   %esi
80100805:	53                   	push   %ebx
  int c, doprocdump = 0;
80100806:	31 f6                	xor    %esi,%esi
{
80100808:	83 ec 18             	sub    $0x18,%esp
8010080b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010080e:	68 40 b5 10 80       	push   $0x8010b540
80100813:	e8 e8 3f 00 00       	call   80104800 <acquire>
  while((c = getc()) >= 0){
80100818:	83 c4 10             	add    $0x10,%esp
8010081b:	90                   	nop
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	ff d3                	call   *%ebx
80100822:	85 c0                	test   %eax,%eax
80100824:	89 c7                	mov    %eax,%edi
80100826:	78 48                	js     80100870 <consoleintr+0x70>
    switch(c){
80100828:	83 ff 10             	cmp    $0x10,%edi
8010082b:	0f 84 e7 00 00 00    	je     80100918 <consoleintr+0x118>
80100831:	7e 5d                	jle    80100890 <consoleintr+0x90>
80100833:	83 ff 15             	cmp    $0x15,%edi
80100836:	0f 84 ec 00 00 00    	je     80100928 <consoleintr+0x128>
8010083c:	83 ff 7f             	cmp    $0x7f,%edi
8010083f:	75 54                	jne    80100895 <consoleintr+0x95>
      if(input.e != input.w){
80100841:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100846:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010084c:	74 d2                	je     80100820 <consoleintr+0x20>
        input.e--;
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100856:	b8 00 01 00 00       	mov    $0x100,%eax
8010085b:	e8 a0 fb ff ff       	call   80100400 <consputc>
  while((c = getc()) >= 0){
80100860:	ff d3                	call   *%ebx
80100862:	85 c0                	test   %eax,%eax
80100864:	89 c7                	mov    %eax,%edi
80100866:	79 c0                	jns    80100828 <consoleintr+0x28>
80100868:	90                   	nop
80100869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 40 b5 10 80       	push   $0x8010b540
80100878:	e8 43 40 00 00       	call   801048c0 <release>
  if(doprocdump) {
8010087d:	83 c4 10             	add    $0x10,%esp
80100880:	85 f6                	test   %esi,%esi
80100882:	0f 85 f8 00 00 00    	jne    80100980 <consoleintr+0x180>
}
80100888:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010088b:	5b                   	pop    %ebx
8010088c:	5e                   	pop    %esi
8010088d:	5f                   	pop    %edi
8010088e:	5d                   	pop    %ebp
8010088f:	c3                   	ret    
    switch(c){
80100890:	83 ff 08             	cmp    $0x8,%edi
80100893:	74 ac                	je     80100841 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100895:	85 ff                	test   %edi,%edi
80100897:	74 87                	je     80100820 <consoleintr+0x20>
80100899:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010089e:	89 c2                	mov    %eax,%edx
801008a0:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008a6:	83 fa 7f             	cmp    $0x7f,%edx
801008a9:	0f 87 71 ff ff ff    	ja     80100820 <consoleintr+0x20>
801008af:	8d 50 01             	lea    0x1(%eax),%edx
801008b2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008b5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008b8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008be:	0f 84 cc 00 00 00    	je     80100990 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008c4:	89 f9                	mov    %edi,%ecx
801008c6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008cc:	89 f8                	mov    %edi,%eax
801008ce:	e8 2d fb ff ff       	call   80100400 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008d3:	83 ff 0a             	cmp    $0xa,%edi
801008d6:	0f 84 c5 00 00 00    	je     801009a1 <consoleintr+0x1a1>
801008dc:	83 ff 04             	cmp    $0x4,%edi
801008df:	0f 84 bc 00 00 00    	je     801009a1 <consoleintr+0x1a1>
801008e5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008ea:	83 e8 80             	sub    $0xffffff80,%eax
801008ed:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
801008f3:	0f 85 27 ff ff ff    	jne    80100820 <consoleintr+0x20>
          wakeup(&input.r);
801008f9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801008fc:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100901:	68 c0 0f 11 80       	push   $0x80110fc0
80100906:	e8 55 38 00 00       	call   80104160 <wakeup>
8010090b:	83 c4 10             	add    $0x10,%esp
8010090e:	e9 0d ff ff ff       	jmp    80100820 <consoleintr+0x20>
80100913:	90                   	nop
80100914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100918:	be 01 00 00 00       	mov    $0x1,%esi
8010091d:	e9 fe fe ff ff       	jmp    80100820 <consoleintr+0x20>
80100922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100928:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010092d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100933:	75 2b                	jne    80100960 <consoleintr+0x160>
80100935:	e9 e6 fe ff ff       	jmp    80100820 <consoleintr+0x20>
8010093a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100940:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100945:	b8 00 01 00 00       	mov    $0x100,%eax
8010094a:	e8 b1 fa ff ff       	call   80100400 <consputc>
      while(input.e != input.w &&
8010094f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100954:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010095a:	0f 84 c0 fe ff ff    	je     80100820 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100960:	83 e8 01             	sub    $0x1,%eax
80100963:	89 c2                	mov    %eax,%edx
80100965:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100968:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
8010096f:	75 cf                	jne    80100940 <consoleintr+0x140>
80100971:	e9 aa fe ff ff       	jmp    80100820 <consoleintr+0x20>
80100976:	8d 76 00             	lea    0x0(%esi),%esi
80100979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100980:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100983:	5b                   	pop    %ebx
80100984:	5e                   	pop    %esi
80100985:	5f                   	pop    %edi
80100986:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100987:	e9 d4 38 00 00       	jmp    80104260 <procdump>
8010098c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100990:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
80100997:	b8 0a 00 00 00       	mov    $0xa,%eax
8010099c:	e8 5f fa ff ff       	call   80100400 <consputc>
801009a1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801009a6:	e9 4e ff ff ff       	jmp    801008f9 <consoleintr+0xf9>
801009ab:	90                   	nop
801009ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009b0 <consoleinit>:

void
consoleinit(void)
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009b6:	68 a8 84 10 80       	push   $0x801084a8
801009bb:	68 40 b5 10 80       	push   $0x8010b540
801009c0:	e8 fb 3c 00 00       	call   801046c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009c5:	58                   	pop    %eax
801009c6:	5a                   	pop    %edx
801009c7:	6a 00                	push   $0x0
801009c9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009cb:	c7 05 8c 19 11 80 f0 	movl   $0x801005f0,0x8011198c
801009d2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801009d5:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
801009dc:	02 10 80 
  cons.locking = 1;
801009df:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
801009e6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009e9:	e8 c2 19 00 00       	call   801023b0 <ioapicenable>
}
801009ee:	83 c4 10             	add    $0x10,%esp
801009f1:	c9                   	leave  
801009f2:	c3                   	ret    
801009f3:	66 90                	xchg   %ax,%ax
801009f5:	66 90                	xchg   %ax,%ax
801009f7:	66 90                	xchg   %ax,%ax
801009f9:	66 90                	xchg   %ax,%ax
801009fb:	66 90                	xchg   %ax,%ax
801009fd:	66 90                	xchg   %ax,%ax
801009ff:	90                   	nop

80100a00 <exec>:
  struct thread thread[NTHREAD];
} ptable;

int
exec(char *path, char **argv)
{
80100a00:	55                   	push   %ebp
80100a01:	89 e5                	mov    %esp,%ebp
80100a03:	57                   	push   %edi
80100a04:	56                   	push   %esi
80100a05:	53                   	push   %ebx
80100a06:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct thread *t;
  struct proc *curproc = myproc();
80100a0c:	e8 7f 2e 00 00       	call   80103890 <myproc>
80100a11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  struct thread *curthd = mythd();
80100a17:	e8 a4 2e 00 00       	call   801038c0 <mythd>
80100a1c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)

  begin_op();
80100a22:	e8 59 22 00 00       	call   80102c80 <begin_op>

  if((ip = namei(path)) == 0){
80100a27:	83 ec 0c             	sub    $0xc,%esp
80100a2a:	ff 75 08             	pushl  0x8(%ebp)
80100a2d:	e8 8e 15 00 00       	call   80101fc0 <namei>
80100a32:	83 c4 10             	add    $0x10,%esp
80100a35:	85 c0                	test   %eax,%eax
80100a37:	0f 84 8e 01 00 00    	je     80100bcb <exec+0x1cb>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a3d:	83 ec 0c             	sub    $0xc,%esp
80100a40:	89 c3                	mov    %eax,%ebx
80100a42:	50                   	push   %eax
80100a43:	e8 18 0d 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a48:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a4e:	6a 34                	push   $0x34
80100a50:	6a 00                	push   $0x0
80100a52:	50                   	push   %eax
80100a53:	53                   	push   %ebx
80100a54:	e8 e7 0f 00 00       	call   80101a40 <readi>
80100a59:	83 c4 20             	add    $0x20,%esp
80100a5c:	83 f8 34             	cmp    $0x34,%eax
80100a5f:	74 1f                	je     80100a80 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a61:	83 ec 0c             	sub    $0xc,%esp
80100a64:	53                   	push   %ebx
80100a65:	e8 86 0f 00 00       	call   801019f0 <iunlockput>
    end_op();
80100a6a:	e8 81 22 00 00       	call   80102cf0 <end_op>
80100a6f:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7a:	5b                   	pop    %ebx
80100a7b:	5e                   	pop    %esi
80100a7c:	5f                   	pop    %edi
80100a7d:	5d                   	pop    %ebp
80100a7e:	c3                   	ret    
80100a7f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100a80:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a87:	45 4c 46 
80100a8a:	75 d5                	jne    80100a61 <exec+0x61>
  if((pgdir = setupkvm()) == 0)
80100a8c:	e8 6f 6a 00 00       	call   80107500 <setupkvm>
80100a91:	85 c0                	test   %eax,%eax
80100a93:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100a99:	74 c6                	je     80100a61 <exec+0x61>
  sz = 0;
80100a9b:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a9d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aa4:	00 
80100aa5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100aab:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100ab1:	0f 84 a5 02 00 00    	je     80100d5c <exec+0x35c>
80100ab7:	31 f6                	xor    %esi,%esi
80100ab9:	eb 7f                	jmp    80100b3a <exec+0x13a>
80100abb:	90                   	nop
80100abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ac7:	75 63                	jne    80100b2c <exec+0x12c>
    if(ph.memsz < ph.filesz)
80100ac9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100acf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ad5:	0f 82 86 00 00 00    	jb     80100b61 <exec+0x161>
80100adb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae1:	72 7e                	jb     80100b61 <exec+0x161>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ae3:	83 ec 04             	sub    $0x4,%esp
80100ae6:	50                   	push   %eax
80100ae7:	57                   	push   %edi
80100ae8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100aee:	e8 2d 68 00 00       	call   80107320 <allocuvm>
80100af3:	83 c4 10             	add    $0x10,%esp
80100af6:	85 c0                	test   %eax,%eax
80100af8:	89 c7                	mov    %eax,%edi
80100afa:	74 65                	je     80100b61 <exec+0x161>
    if(ph.vaddr % PGSIZE != 0)
80100afc:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b02:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b07:	75 58                	jne    80100b61 <exec+0x161>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b09:	83 ec 0c             	sub    $0xc,%esp
80100b0c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b12:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b18:	53                   	push   %ebx
80100b19:	50                   	push   %eax
80100b1a:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b20:	e8 3b 67 00 00       	call   80107260 <loaduvm>
80100b25:	83 c4 20             	add    $0x20,%esp
80100b28:	85 c0                	test   %eax,%eax
80100b2a:	78 35                	js     80100b61 <exec+0x161>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b33:	83 c6 01             	add    $0x1,%esi
80100b36:	39 f0                	cmp    %esi,%eax
80100b38:	7e 3d                	jle    80100b77 <exec+0x177>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b3a:	89 f0                	mov    %esi,%eax
80100b3c:	6a 20                	push   $0x20
80100b3e:	c1 e0 05             	shl    $0x5,%eax
80100b41:	03 85 e8 fe ff ff    	add    -0x118(%ebp),%eax
80100b47:	50                   	push   %eax
80100b48:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b4e:	50                   	push   %eax
80100b4f:	53                   	push   %ebx
80100b50:	e8 eb 0e 00 00       	call   80101a40 <readi>
80100b55:	83 c4 10             	add    $0x10,%esp
80100b58:	83 f8 20             	cmp    $0x20,%eax
80100b5b:	0f 84 5f ff ff ff    	je     80100ac0 <exec+0xc0>
    freevm(pgdir);
80100b61:	83 ec 0c             	sub    $0xc,%esp
80100b64:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b6a:	e8 11 69 00 00       	call   80107480 <freevm>
80100b6f:	83 c4 10             	add    $0x10,%esp
80100b72:	e9 ea fe ff ff       	jmp    80100a61 <exec+0x61>
80100b77:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b7d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b83:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b89:	83 ec 0c             	sub    $0xc,%esp
80100b8c:	53                   	push   %ebx
80100b8d:	e8 5e 0e 00 00       	call   801019f0 <iunlockput>
  end_op();
80100b92:	e8 59 21 00 00       	call   80102cf0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b97:	83 c4 0c             	add    $0xc,%esp
80100b9a:	56                   	push   %esi
80100b9b:	57                   	push   %edi
80100b9c:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100ba2:	e8 79 67 00 00       	call   80107320 <allocuvm>
80100ba7:	83 c4 10             	add    $0x10,%esp
80100baa:	85 c0                	test   %eax,%eax
80100bac:	89 c6                	mov    %eax,%esi
80100bae:	75 3a                	jne    80100bea <exec+0x1ea>
    freevm(pgdir);
80100bb0:	83 ec 0c             	sub    $0xc,%esp
80100bb3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bb9:	e8 c2 68 00 00       	call   80107480 <freevm>
80100bbe:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc6:	e9 ac fe ff ff       	jmp    80100a77 <exec+0x77>
    end_op();
80100bcb:	e8 20 21 00 00       	call   80102cf0 <end_op>
    cprintf("exec: fail\n");
80100bd0:	83 ec 0c             	sub    $0xc,%esp
80100bd3:	68 c1 84 10 80       	push   $0x801084c1
80100bd8:	e8 73 fa ff ff       	call   80100650 <cprintf>
    return -1;
80100bdd:	83 c4 10             	add    $0x10,%esp
80100be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100be5:	e9 8d fe ff ff       	jmp    80100a77 <exec+0x77>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf0:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bf3:	31 ff                	xor    %edi,%edi
80100bf5:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf7:	50                   	push   %eax
80100bf8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100bfe:	e8 9d 69 00 00       	call   801075a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c03:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c0f:	8b 00                	mov    (%eax),%eax
80100c11:	85 c0                	test   %eax,%eax
80100c13:	74 70                	je     80100c85 <exec+0x285>
80100c15:	89 b5 e8 fe ff ff    	mov    %esi,-0x118(%ebp)
80100c1b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100c21:	eb 0a                	jmp    80100c2d <exec+0x22d>
80100c23:	90                   	nop
80100c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c28:	83 ff 20             	cmp    $0x20,%edi
80100c2b:	74 83                	je     80100bb0 <exec+0x1b0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c2d:	83 ec 0c             	sub    $0xc,%esp
80100c30:	50                   	push   %eax
80100c31:	e8 fa 3e 00 00       	call   80104b30 <strlen>
80100c36:	f7 d0                	not    %eax
80100c38:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c3d:	59                   	pop    %ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3e:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c41:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c44:	e8 e7 3e 00 00       	call   80104b30 <strlen>
80100c49:	83 c0 01             	add    $0x1,%eax
80100c4c:	50                   	push   %eax
80100c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c50:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c53:	53                   	push   %ebx
80100c54:	56                   	push   %esi
80100c55:	e8 a6 6a 00 00       	call   80107700 <copyout>
80100c5a:	83 c4 20             	add    $0x20,%esp
80100c5d:	85 c0                	test   %eax,%eax
80100c5f:	0f 88 4b ff ff ff    	js     80100bb0 <exec+0x1b0>
  for(argc = 0; argv[argc]; argc++) {
80100c65:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c68:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c6f:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c72:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c78:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c7b:	85 c0                	test   %eax,%eax
80100c7d:	75 a9                	jne    80100c28 <exec+0x228>
80100c7f:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c85:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c8c:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c8e:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c95:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c99:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca0:	ff ff ff 
  ustack[1] = argc;
80100ca3:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca9:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cab:	83 c0 0c             	add    $0xc,%eax
80100cae:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb0:	50                   	push   %eax
80100cb1:	52                   	push   %edx
80100cb2:	53                   	push   %ebx
80100cb3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb9:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbf:	e8 3c 6a 00 00       	call   80107700 <copyout>
80100cc4:	83 c4 10             	add    $0x10,%esp
80100cc7:	85 c0                	test   %eax,%eax
80100cc9:	0f 88 e1 fe ff ff    	js     80100bb0 <exec+0x1b0>
  acquire(&ptable.lock);
80100ccf:	83 ec 0c             	sub    $0xc,%esp
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++){
80100cd2:	bf 94 60 11 80       	mov    $0x80116094,%edi
  acquire(&ptable.lock);
80100cd7:	68 60 3d 11 80       	push   $0x80113d60
80100cdc:	e8 1f 3b 00 00       	call   80104800 <acquire>
  if(allthdexit() == -1){
80100ce1:	e8 fa 72 00 00       	call   80107fe0 <allthdexit>
80100ce6:	83 c4 10             	add    $0x10,%esp
80100ce9:	83 f8 ff             	cmp    $0xffffffff,%eax
80100cec:	0f 84 12 01 00 00    	je     80100e04 <exec+0x404>
80100cf2:	89 b5 e8 fe ff ff    	mov    %esi,-0x118(%ebp)
80100cf8:	89 9d e4 fe ff ff    	mov    %ebx,-0x11c(%ebp)
80100cfe:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100d04:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100d0a:	eb 0f                	jmp    80100d1b <exec+0x31b>
80100d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++){
80100d10:	83 c7 20             	add    $0x20,%edi
80100d13:	81 ff 94 80 11 80    	cmp    $0x80118094,%edi
80100d19:	73 4b                	jae    80100d66 <exec+0x366>
    if(t == curthd)
80100d1b:	39 fe                	cmp    %edi,%esi
80100d1d:	74 f1                	je     80100d10 <exec+0x310>
    if(t->mp == curproc && t->state == ZOMBIE){
80100d1f:	39 5f 10             	cmp    %ebx,0x10(%edi)
80100d22:	75 ec                	jne    80100d10 <exec+0x310>
80100d24:	83 7f 08 01          	cmpl   $0x1,0x8(%edi)
80100d28:	75 e6                	jne    80100d10 <exec+0x310>
      kfree(t->kstack);
80100d2a:	83 ec 0c             	sub    $0xc,%esp
80100d2d:	ff 77 04             	pushl  0x4(%edi)
80100d30:	e8 bb 16 00 00       	call   801023f0 <kfree>
      t->kstack = 0;
80100d35:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
      t->usp = 0;
80100d3c:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
      t->mp = 0;
80100d42:	83 c4 10             	add    $0x10,%esp
      t->state = UNUSED;
80100d45:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
      t->tid = 0;
80100d4c:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
      t->mp = 0;
80100d53:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
80100d5a:	eb b4                	jmp    80100d10 <exec+0x310>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d5c:	be 00 20 00 00       	mov    $0x2000,%esi
80100d61:	e9 23 fe ff ff       	jmp    80100b89 <exec+0x189>
  for(last=s=path; *s; s++)
80100d66:	8b 45 08             	mov    0x8(%ebp),%eax
80100d69:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
80100d6f:	8b 9d e4 fe ff ff    	mov    -0x11c(%ebp),%ebx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 17                	je     80100d93 <exec+0x393>
80100d7c:	8b 55 08             	mov    0x8(%ebp),%edx
80100d7f:	89 d1                	mov    %edx,%ecx
80100d81:	83 c1 01             	add    $0x1,%ecx
80100d84:	3c 2f                	cmp    $0x2f,%al
80100d86:	0f b6 01             	movzbl (%ecx),%eax
80100d89:	0f 44 d1             	cmove  %ecx,%edx
80100d8c:	84 c0                	test   %al,%al
80100d8e:	75 f1                	jne    80100d81 <exec+0x381>
80100d90:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d93:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d99:	50                   	push   %eax
80100d9a:	6a 10                	push   $0x10
80100d9c:	ff 75 08             	pushl  0x8(%ebp)
80100d9f:	8d 47 60             	lea    0x60(%edi),%eax
80100da2:	50                   	push   %eax
80100da3:	e8 48 3d 00 00       	call   80104af0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da8:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100dae:	89 f9                	mov    %edi,%ecx
80100db0:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db3:	89 31                	mov    %esi,(%ecx)
  curproc->fslist = 0;
80100db5:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%ecx)
80100dbc:	00 00 00 
  curproc->pgdir = pgdir;
80100dbf:	89 41 04             	mov    %eax,0x4(%ecx)
  curthd->usp = sz;
80100dc2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100dc8:	89 30                	mov    %esi,(%eax)
  curthd->tf->eip = elf.entry;  // main
80100dca:	89 c6                	mov    %eax,%esi
80100dcc:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dd2:	8b 40 14             	mov    0x14(%eax),%eax
80100dd5:	89 50 38             	mov    %edx,0x38(%eax)
  curthd->tf->esp = sp;
80100dd8:	8b 46 14             	mov    0x14(%esi),%eax
80100ddb:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dde:	89 0c 24             	mov    %ecx,(%esp)
80100de1:	e8 da 62 00 00       	call   801070c0 <switchuvm>
  freevm(oldpgdir);
80100de6:	89 3c 24             	mov    %edi,(%esp)
80100de9:	e8 92 66 00 00       	call   80107480 <freevm>
  release(&ptable.lock);
80100dee:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80100df5:	e8 c6 3a 00 00       	call   801048c0 <release>
  return 0;
80100dfa:	83 c4 10             	add    $0x10,%esp
80100dfd:	31 c0                	xor    %eax,%eax
80100dff:	e9 73 fc ff ff       	jmp    80100a77 <exec+0x77>
    release(&ptable.lock);
80100e04:	83 ec 0c             	sub    $0xc,%esp
80100e07:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e0d:	68 60 3d 11 80       	push   $0x80113d60
80100e12:	e8 a9 3a 00 00       	call   801048c0 <release>
    freevm(pgdir);
80100e17:	5a                   	pop    %edx
80100e18:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100e1e:	e8 5d 66 00 00       	call   80107480 <freevm>
80100e23:	83 c4 10             	add    $0x10,%esp
80100e26:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100e2c:	e9 46 fc ff ff       	jmp    80100a77 <exec+0x77>
80100e31:	66 90                	xchg   %ax,%ax
80100e33:	66 90                	xchg   %ax,%ax
80100e35:	66 90                	xchg   %ax,%ax
80100e37:	66 90                	xchg   %ax,%ax
80100e39:	66 90                	xchg   %ax,%ax
80100e3b:	66 90                	xchg   %ax,%ax
80100e3d:	66 90                	xchg   %ax,%ax
80100e3f:	90                   	nop

80100e40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e46:	68 cd 84 10 80       	push   $0x801084cd
80100e4b:	68 e0 0f 11 80       	push   $0x80110fe0
80100e50:	e8 6b 38 00 00       	call   801046c0 <initlock>
}
80100e55:	83 c4 10             	add    $0x10,%esp
80100e58:	c9                   	leave  
80100e59:	c3                   	ret    
80100e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e64:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100e69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e6c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e71:	e8 8a 39 00 00       	call   80104800 <acquire>
80100e76:	83 c4 10             	add    $0x10,%esp
80100e79:	eb 10                	jmp    80100e8b <filealloc+0x2b>
80100e7b:	90                   	nop
80100e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e80:	83 c3 18             	add    $0x18,%ebx
80100e83:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100e89:	73 25                	jae    80100eb0 <filealloc+0x50>
    if(f->ref == 0){
80100e8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	75 ee                	jne    80100e80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e92:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e9c:	68 e0 0f 11 80       	push   $0x80110fe0
80100ea1:	e8 1a 3a 00 00       	call   801048c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ea6:	89 d8                	mov    %ebx,%eax
      return f;
80100ea8:	83 c4 10             	add    $0x10,%esp
}
80100eab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eae:	c9                   	leave  
80100eaf:	c3                   	ret    
  release(&ftable.lock);
80100eb0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100eb3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100eb5:	68 e0 0f 11 80       	push   $0x80110fe0
80100eba:	e8 01 3a 00 00       	call   801048c0 <release>
}
80100ebf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ec1:	83 c4 10             	add    $0x10,%esp
}
80100ec4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ec7:	c9                   	leave  
80100ec8:	c3                   	ret    
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	53                   	push   %ebx
80100ed4:	83 ec 10             	sub    $0x10,%esp
80100ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eda:	68 e0 0f 11 80       	push   $0x80110fe0
80100edf:	e8 1c 39 00 00       	call   80104800 <acquire>
  if(f->ref < 1)
80100ee4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ee7:	83 c4 10             	add    $0x10,%esp
80100eea:	85 c0                	test   %eax,%eax
80100eec:	7e 1a                	jle    80100f08 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100eee:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ef1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ef4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ef7:	68 e0 0f 11 80       	push   $0x80110fe0
80100efc:	e8 bf 39 00 00       	call   801048c0 <release>
  return f;
}
80100f01:	89 d8                	mov    %ebx,%eax
80100f03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f06:	c9                   	leave  
80100f07:	c3                   	ret    
    panic("filedup");
80100f08:	83 ec 0c             	sub    $0xc,%esp
80100f0b:	68 d4 84 10 80       	push   $0x801084d4
80100f10:	e8 6b f4 ff ff       	call   80100380 <panic>
80100f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f20 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	83 ec 28             	sub    $0x28,%esp
80100f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f2c:	68 e0 0f 11 80       	push   $0x80110fe0
80100f31:	e8 ca 38 00 00       	call   80104800 <acquire>
  if(f->ref < 1)
80100f36:	8b 43 04             	mov    0x4(%ebx),%eax
80100f39:	83 c4 10             	add    $0x10,%esp
80100f3c:	85 c0                	test   %eax,%eax
80100f3e:	0f 8e 9b 00 00 00    	jle    80100fdf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f44:	83 e8 01             	sub    $0x1,%eax
80100f47:	85 c0                	test   %eax,%eax
80100f49:	89 43 04             	mov    %eax,0x4(%ebx)
80100f4c:	74 1a                	je     80100f68 <fileclose+0x48>
    release(&ftable.lock);
80100f4e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f58:	5b                   	pop    %ebx
80100f59:	5e                   	pop    %esi
80100f5a:	5f                   	pop    %edi
80100f5b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f5c:	e9 5f 39 00 00       	jmp    801048c0 <release>
80100f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f68:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f6c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f6e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f71:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f74:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f7d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f80:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100f85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f88:	e8 33 39 00 00       	call   801048c0 <release>
  if(ff.type == FD_PIPE)
80100f8d:	83 c4 10             	add    $0x10,%esp
80100f90:	83 ff 01             	cmp    $0x1,%edi
80100f93:	74 13                	je     80100fa8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f95:	83 ff 02             	cmp    $0x2,%edi
80100f98:	74 26                	je     80100fc0 <fileclose+0xa0>
}
80100f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9d:	5b                   	pop    %ebx
80100f9e:	5e                   	pop    %esi
80100f9f:	5f                   	pop    %edi
80100fa0:	5d                   	pop    %ebp
80100fa1:	c3                   	ret    
80100fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100fa8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fac:	83 ec 08             	sub    $0x8,%esp
80100faf:	53                   	push   %ebx
80100fb0:	56                   	push   %esi
80100fb1:	e8 7a 24 00 00       	call   80103430 <pipeclose>
80100fb6:	83 c4 10             	add    $0x10,%esp
80100fb9:	eb df                	jmp    80100f9a <fileclose+0x7a>
80100fbb:	90                   	nop
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100fc0:	e8 bb 1c 00 00       	call   80102c80 <begin_op>
    iput(ff.ip);
80100fc5:	83 ec 0c             	sub    $0xc,%esp
80100fc8:	ff 75 e0             	pushl  -0x20(%ebp)
80100fcb:	e8 c0 08 00 00       	call   80101890 <iput>
    end_op();
80100fd0:	83 c4 10             	add    $0x10,%esp
}
80100fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd6:	5b                   	pop    %ebx
80100fd7:	5e                   	pop    %esi
80100fd8:	5f                   	pop    %edi
80100fd9:	5d                   	pop    %ebp
    end_op();
80100fda:	e9 11 1d 00 00       	jmp    80102cf0 <end_op>
    panic("fileclose");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 dc 84 10 80       	push   $0x801084dc
80100fe7:	e8 94 f3 ff ff       	call   80100380 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	pushl  0x10(%ebx)
80101005:	e8 56 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	pushl  0xc(%ebp)
8010100f:	ff 73 10             	pushl  0x10(%ebx)
80101012:	e8 f9 09 00 00       	call   80101a10 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	pushl  0x10(%ebx)
8010101b:	e8 20 08 00 00       	call   80101840 <iunlock>
    return 0;
80101020:	83 c4 10             	add    $0x10,%esp
80101023:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101035:	eb ee                	jmp    80101025 <filestat+0x35>
80101037:	89 f6                	mov    %esi,%esi
80101039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	pushl  0x10(%ebx)
8010106a:	e8 f1 06 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	pushl  0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	pushl  0x10(%ebx)
80101077:	e8 c4 09 00 00       	call   80101a40 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	85 c0                	test   %eax,%eax
80101081:	89 c6                	mov    %eax,%esi
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	pushl  0x10(%ebx)
8010108e:	e8 ad 07 00 00       	call   80101840 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 3e 25 00 00       	jmp    801035f0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 e6 84 10 80       	push   $0x801084e6
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 75 08             	mov    0x8(%ebp),%esi
801010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010df:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e6:	8b 45 10             	mov    0x10(%ebp),%eax
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 aa 00 00 00    	je     8010119c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 06                	mov    (%esi),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 c3 00 00 00    	je     801011c0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 d9 00 00 00    	jne    801011df <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 ff                	xor    %edi,%edi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 34                	jg     80101143 <filewrite+0x73>
8010110f:	e9 9c 00 00 00       	jmp    801011b0 <filewrite+0xe0>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101121:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101124:	e8 17 07 00 00       	call   80101840 <iunlock>
      end_op();
80101129:	e8 c2 1b 00 00       	call   80102cf0 <end_op>
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101134:	39 c3                	cmp    %eax,%ebx
80101136:	0f 85 96 00 00 00    	jne    801011d2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010113c:	01 df                	add    %ebx,%edi
    while(i < n){
8010113e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101141:	7e 6d                	jle    801011b0 <filewrite+0xe0>
      int n1 = n - i;
80101143:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101146:	b8 00 06 00 00       	mov    $0x600,%eax
8010114b:	29 fb                	sub    %edi,%ebx
8010114d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101153:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101156:	e8 25 1b 00 00       	call   80102c80 <begin_op>
      ilock(f->ip);
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	ff 76 10             	pushl  0x10(%esi)
80101161:	e8 fa 05 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101166:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101169:	53                   	push   %ebx
8010116a:	ff 76 14             	pushl  0x14(%esi)
8010116d:	01 f8                	add    %edi,%eax
8010116f:	50                   	push   %eax
80101170:	ff 76 10             	pushl  0x10(%esi)
80101173:	e8 c8 09 00 00       	call   80101b40 <writei>
80101178:	83 c4 20             	add    $0x20,%esp
8010117b:	85 c0                	test   %eax,%eax
8010117d:	7f 99                	jg     80101118 <filewrite+0x48>
      iunlock(f->ip);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 76 10             	pushl  0x10(%esi)
80101185:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101188:	e8 b3 06 00 00       	call   80101840 <iunlock>
      end_op();
8010118d:	e8 5e 1b 00 00       	call   80102cf0 <end_op>
      if(r < 0)
80101192:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101195:	83 c4 10             	add    $0x10,%esp
80101198:	85 c0                	test   %eax,%eax
8010119a:	74 98                	je     80101134 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010119c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010119f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801011a4:	89 f8                	mov    %edi,%eax
801011a6:	5b                   	pop    %ebx
801011a7:	5e                   	pop    %esi
801011a8:	5f                   	pop    %edi
801011a9:	5d                   	pop    %ebp
801011aa:	c3                   	ret    
801011ab:	90                   	nop
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801011b0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801011b3:	75 e7                	jne    8010119c <filewrite+0xcc>
}
801011b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b8:	89 f8                	mov    %edi,%eax
801011ba:	5b                   	pop    %ebx
801011bb:	5e                   	pop    %esi
801011bc:	5f                   	pop    %edi
801011bd:	5d                   	pop    %ebp
801011be:	c3                   	ret    
801011bf:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801011c0:	8b 46 0c             	mov    0xc(%esi),%eax
801011c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c9:	5b                   	pop    %ebx
801011ca:	5e                   	pop    %esi
801011cb:	5f                   	pop    %edi
801011cc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011cd:	e9 fe 22 00 00       	jmp    801034d0 <pipewrite>
        panic("short filewrite");
801011d2:	83 ec 0c             	sub    $0xc,%esp
801011d5:	68 ef 84 10 80       	push   $0x801084ef
801011da:	e8 a1 f1 ff ff       	call   80100380 <panic>
  panic("filewrite");
801011df:	83 ec 0c             	sub    $0xc,%esp
801011e2:	68 f5 84 10 80       	push   $0x801084f5
801011e7:	e8 94 f1 ff ff       	call   80100380 <panic>
801011ec:	66 90                	xchg   %ax,%ax
801011ee:	66 90                	xchg   %ax,%ax

801011f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	56                   	push   %esi
801011f4:	53                   	push   %ebx
801011f5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011f7:	c1 ea 0c             	shr    $0xc,%edx
801011fa:	03 15 f8 19 11 80    	add    0x801119f8,%edx
80101200:	83 ec 08             	sub    $0x8,%esp
80101203:	52                   	push   %edx
80101204:	50                   	push   %eax
80101205:	e8 c6 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010120a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010120c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010120f:	ba 01 00 00 00       	mov    $0x1,%edx
80101214:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101217:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010121d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101220:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101222:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101227:	85 d1                	test   %edx,%ecx
80101229:	74 25                	je     80101250 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010122b:	f7 d2                	not    %edx
8010122d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010122f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101232:	21 ca                	and    %ecx,%edx
80101234:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101238:	56                   	push   %esi
80101239:	e8 12 1c 00 00       	call   80102e50 <log_write>
  brelse(bp);
8010123e:	89 34 24             	mov    %esi,(%esp)
80101241:	e8 9a ef ff ff       	call   801001e0 <brelse>
}
80101246:	83 c4 10             	add    $0x10,%esp
80101249:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010124c:	5b                   	pop    %ebx
8010124d:	5e                   	pop    %esi
8010124e:	5d                   	pop    %ebp
8010124f:	c3                   	ret    
    panic("freeing free block");
80101250:	83 ec 0c             	sub    $0xc,%esp
80101253:	68 ff 84 10 80       	push   $0x801084ff
80101258:	e8 23 f1 ff ff       	call   80100380 <panic>
8010125d:	8d 76 00             	lea    0x0(%esi),%esi

80101260 <balloc>:
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101269:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
8010126f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101272:	85 c9                	test   %ecx,%ecx
80101274:	0f 84 87 00 00 00    	je     80101301 <balloc+0xa1>
8010127a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101281:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101284:	83 ec 08             	sub    $0x8,%esp
80101287:	89 f0                	mov    %esi,%eax
80101289:	c1 f8 0c             	sar    $0xc,%eax
8010128c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101292:	50                   	push   %eax
80101293:	ff 75 d8             	pushl  -0x28(%ebp)
80101296:	e8 35 ee ff ff       	call   801000d0 <bread>
8010129b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129e:	a1 e0 19 11 80       	mov    0x801119e0,%eax
801012a3:	83 c4 10             	add    $0x10,%esp
801012a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012a9:	31 c0                	xor    %eax,%eax
801012ab:	eb 2f                	jmp    801012dc <balloc+0x7c>
801012ad:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012b0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012b5:	bb 01 00 00 00       	mov    $0x1,%ebx
801012ba:	83 e1 07             	and    $0x7,%ecx
801012bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012bf:	89 c1                	mov    %eax,%ecx
801012c1:	c1 f9 03             	sar    $0x3,%ecx
801012c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012c9:	85 df                	test   %ebx,%edi
801012cb:	89 fa                	mov    %edi,%edx
801012cd:	74 41                	je     80101310 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012cf:	83 c0 01             	add    $0x1,%eax
801012d2:	83 c6 01             	add    $0x1,%esi
801012d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012da:	74 05                	je     801012e1 <balloc+0x81>
801012dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012df:	77 cf                	ja     801012b0 <balloc+0x50>
    brelse(bp);
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012e7:	e8 f4 ee ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012f3:	83 c4 10             	add    $0x10,%esp
801012f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012f9:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801012ff:	77 80                	ja     80101281 <balloc+0x21>
  panic("balloc: out of blocks");
80101301:	83 ec 0c             	sub    $0xc,%esp
80101304:	68 12 85 10 80       	push   $0x80108512
80101309:	e8 72 f0 ff ff       	call   80100380 <panic>
8010130e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101313:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101316:	09 da                	or     %ebx,%edx
80101318:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010131c:	57                   	push   %edi
8010131d:	e8 2e 1b 00 00       	call   80102e50 <log_write>
        brelse(bp);
80101322:	89 3c 24             	mov    %edi,(%esp)
80101325:	e8 b6 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010132a:	58                   	pop    %eax
8010132b:	5a                   	pop    %edx
8010132c:	56                   	push   %esi
8010132d:	ff 75 d8             	pushl  -0x28(%ebp)
80101330:	e8 9b ed ff ff       	call   801000d0 <bread>
80101335:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101337:	8d 40 5c             	lea    0x5c(%eax),%eax
8010133a:	83 c4 0c             	add    $0xc,%esp
8010133d:	68 00 02 00 00       	push   $0x200
80101342:	6a 00                	push   $0x0
80101344:	50                   	push   %eax
80101345:	e8 c6 35 00 00       	call   80104910 <memset>
  log_write(bp);
8010134a:	89 1c 24             	mov    %ebx,(%esp)
8010134d:	e8 fe 1a 00 00       	call   80102e50 <log_write>
  brelse(bp);
80101352:	89 1c 24             	mov    %ebx,(%esp)
80101355:	e8 86 ee ff ff       	call   801001e0 <brelse>
}
8010135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135d:	89 f0                	mov    %esi,%eax
8010135f:	5b                   	pop    %ebx
80101360:	5e                   	pop    %esi
80101361:	5f                   	pop    %edi
80101362:	5d                   	pop    %ebp
80101363:	c3                   	ret    
80101364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010136a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101370 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	56                   	push   %esi
80101375:	53                   	push   %ebx
80101376:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101378:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010137f:	83 ec 28             	sub    $0x28,%esp
80101382:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101385:	68 00 1a 11 80       	push   $0x80111a00
8010138a:	e8 71 34 00 00       	call   80104800 <acquire>
8010138f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101392:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101395:	eb 17                	jmp    801013ae <iget+0x3e>
80101397:	89 f6                	mov    %esi,%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801013a0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a6:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801013ac:	73 22                	jae    801013d0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013ae:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013b1:	85 c9                	test   %ecx,%ecx
801013b3:	7e 04                	jle    801013b9 <iget+0x49>
801013b5:	39 3b                	cmp    %edi,(%ebx)
801013b7:	74 4f                	je     80101408 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013b9:	85 f6                	test   %esi,%esi
801013bb:	75 e3                	jne    801013a0 <iget+0x30>
801013bd:	85 c9                	test   %ecx,%ecx
801013bf:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013c2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013c8:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801013ce:	72 de                	jb     801013ae <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013d0:	85 f6                	test   %esi,%esi
801013d2:	74 5b                	je     8010142f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013d4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013d7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013dc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013e3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013ea:	68 00 1a 11 80       	push   $0x80111a00
801013ef:	e8 cc 34 00 00       	call   801048c0 <release>

  return ip;
801013f4:	83 c4 10             	add    $0x10,%esp
}
801013f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013fa:	89 f0                	mov    %esi,%eax
801013fc:	5b                   	pop    %ebx
801013fd:	5e                   	pop    %esi
801013fe:	5f                   	pop    %edi
801013ff:	5d                   	pop    %ebp
80101400:	c3                   	ret    
80101401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101408:	39 53 04             	cmp    %edx,0x4(%ebx)
8010140b:	75 ac                	jne    801013b9 <iget+0x49>
      release(&icache.lock);
8010140d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101410:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101413:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101415:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
8010141a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010141d:	e8 9e 34 00 00       	call   801048c0 <release>
      return ip;
80101422:	83 c4 10             	add    $0x10,%esp
}
80101425:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101428:	89 f0                	mov    %esi,%eax
8010142a:	5b                   	pop    %ebx
8010142b:	5e                   	pop    %esi
8010142c:	5f                   	pop    %edi
8010142d:	5d                   	pop    %ebp
8010142e:	c3                   	ret    
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 28 85 10 80       	push   $0x80108528
80101437:	e8 44 ef ff ff       	call   80100380 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	53                   	push   %ebx
80101446:	89 c6                	mov    %eax,%esi
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	77 18                	ja     80101468 <bmap+0x28>
80101450:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101453:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101456:	85 db                	test   %ebx,%ebx
80101458:	74 76                	je     801014d0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010145a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010145d:	89 d8                	mov    %ebx,%eax
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5f                   	pop    %edi
80101462:	5d                   	pop    %ebp
80101463:	c3                   	ret    
80101464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101468:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010146b:	83 fb 7f             	cmp    $0x7f,%ebx
8010146e:	0f 87 90 00 00 00    	ja     80101504 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101474:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010147a:	8b 00                	mov    (%eax),%eax
8010147c:	85 d2                	test   %edx,%edx
8010147e:	74 70                	je     801014f0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	52                   	push   %edx
80101484:	50                   	push   %eax
80101485:	e8 46 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010148a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010148e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101491:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101493:	8b 1a                	mov    (%edx),%ebx
80101495:	85 db                	test   %ebx,%ebx
80101497:	75 1d                	jne    801014b6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101499:	8b 06                	mov    (%esi),%eax
8010149b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010149e:	e8 bd fd ff ff       	call   80101260 <balloc>
801014a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014a6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a9:	89 c3                	mov    %eax,%ebx
801014ab:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014ad:	57                   	push   %edi
801014ae:	e8 9d 19 00 00       	call   80102e50 <log_write>
801014b3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801014b6:	83 ec 0c             	sub    $0xc,%esp
801014b9:	57                   	push   %edi
801014ba:	e8 21 ed ff ff       	call   801001e0 <brelse>
801014bf:	83 c4 10             	add    $0x10,%esp
}
801014c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c5:	89 d8                	mov    %ebx,%eax
801014c7:	5b                   	pop    %ebx
801014c8:	5e                   	pop    %esi
801014c9:	5f                   	pop    %edi
801014ca:	5d                   	pop    %ebp
801014cb:	c3                   	ret    
801014cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d0:	8b 00                	mov    (%eax),%eax
801014d2:	e8 89 fd ff ff       	call   80101260 <balloc>
801014d7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801014da:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801014dd:	89 c3                	mov    %eax,%ebx
}
801014df:	89 d8                	mov    %ebx,%eax
801014e1:	5b                   	pop    %ebx
801014e2:	5e                   	pop    %esi
801014e3:	5f                   	pop    %edi
801014e4:	5d                   	pop    %ebp
801014e5:	c3                   	ret    
801014e6:	8d 76 00             	lea    0x0(%esi),%esi
801014e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f0:	e8 6b fd ff ff       	call   80101260 <balloc>
801014f5:	89 c2                	mov    %eax,%edx
801014f7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014fd:	8b 06                	mov    (%esi),%eax
801014ff:	e9 7c ff ff ff       	jmp    80101480 <bmap+0x40>
  panic("bmap: out of range");
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	68 38 85 10 80       	push   $0x80108538
8010150c:	e8 6f ee ff ff       	call   80100380 <panic>
80101511:	eb 0d                	jmp    80101520 <readsb>
80101513:	90                   	nop
80101514:	90                   	nop
80101515:	90                   	nop
80101516:	90                   	nop
80101517:	90                   	nop
80101518:	90                   	nop
80101519:	90                   	nop
8010151a:	90                   	nop
8010151b:	90                   	nop
8010151c:	90                   	nop
8010151d:	90                   	nop
8010151e:	90                   	nop
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	pushl  0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
80101535:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101537:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153a:	83 c4 0c             	add    $0xc,%esp
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 7a 34 00 00       	call   801049c0 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 89 ec ff ff       	jmp    801001e0 <brelse>
80101557:	89 f6                	mov    %esi,%esi
80101559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 4b 85 10 80       	push   $0x8010854b
80101571:	68 00 1a 11 80       	push   $0x80111a00
80101576:	e8 45 31 00 00       	call   801046c0 <initlock>
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 52 85 10 80       	push   $0x80108552
80101588:	53                   	push   %ebx
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010158f:	e8 fc 2f 00 00       	call   80104590 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  readsb(dev, &sb);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	68 e0 19 11 80       	push   $0x801119e0
801015a7:	ff 75 08             	pushl  0x8(%ebp)
801015aa:	e8 71 ff ff ff       	call   80101520 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015af:	ff 35 f8 19 11 80    	pushl  0x801119f8
801015b5:	ff 35 f4 19 11 80    	pushl  0x801119f4
801015bb:	ff 35 f0 19 11 80    	pushl  0x801119f0
801015c1:	ff 35 ec 19 11 80    	pushl  0x801119ec
801015c7:	ff 35 e8 19 11 80    	pushl  0x801119e8
801015cd:	ff 35 e4 19 11 80    	pushl  0x801119e4
801015d3:	ff 35 e0 19 11 80    	pushl  0x801119e0
801015d9:	68 b8 85 10 80       	push   $0x801085b8
801015de:	e8 6d f0 ff ff       	call   80100650 <cprintf>
}
801015e3:	83 c4 30             	add    $0x30,%esp
801015e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015e9:	c9                   	leave  
801015ea:	c3                   	ret    
801015eb:	90                   	nop
801015ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015f0 <ialloc>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	57                   	push   %edi
801015f4:	56                   	push   %esi
801015f5:	53                   	push   %ebx
801015f6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015f9:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
80101600:	8b 45 0c             	mov    0xc(%ebp),%eax
80101603:	8b 75 08             	mov    0x8(%ebp),%esi
80101606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101609:	0f 86 91 00 00 00    	jbe    801016a0 <ialloc+0xb0>
8010160f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101614:	eb 21                	jmp    80101637 <ialloc+0x47>
80101616:	8d 76 00             	lea    0x0(%esi),%esi
80101619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101626:	57                   	push   %edi
80101627:	e8 b4 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101635:	76 69                	jbe    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 d8                	mov    %ebx,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
8010164c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010164e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101650:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 9d 32 00 00       	call   80104910 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 3c 24             	mov    %edi,(%esp)
80101680:	e8 cb 17 00 00       	call   80102e50 <log_write>
      brelse(bp);
80101685:	89 3c 24             	mov    %edi,(%esp)
80101688:	e8 53 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 da                	mov    %ebx,%edx
80101695:	89 f0                	mov    %esi,%eax
}
80101697:	5b                   	pop    %ebx
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 d0 fc ff ff       	jmp    80101370 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 58 85 10 80       	push   $0x80108558
801016a8:	e8 d3 ec ff ff       	call   80100380 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b8:	83 ec 08             	sub    $0x8,%esp
801016bb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016be:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c1:	c1 e8 03             	shr    $0x3,%eax
801016c4:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016ca:	50                   	push   %eax
801016cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801016ce:	e8 fd e9 ff ff       	call   801000d0 <bread>
801016d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801016d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101703:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101707:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010170d:	6a 34                	push   $0x34
8010170f:	53                   	push   %ebx
80101710:	50                   	push   %eax
80101711:	e8 aa 32 00 00       	call   801049c0 <memmove>
  log_write(bp);
80101716:	89 34 24             	mov    %esi,(%esp)
80101719:	e8 32 17 00 00       	call   80102e50 <log_write>
  brelse(bp);
8010171e:	89 75 08             	mov    %esi,0x8(%ebp)
80101721:	83 c4 10             	add    $0x10,%esp
}
80101724:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101727:	5b                   	pop    %ebx
80101728:	5e                   	pop    %esi
80101729:	5d                   	pop    %ebp
  brelse(bp);
8010172a:	e9 b1 ea ff ff       	jmp    801001e0 <brelse>
8010172f:	90                   	nop

80101730 <idup>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	53                   	push   %ebx
80101734:	83 ec 10             	sub    $0x10,%esp
80101737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173a:	68 00 1a 11 80       	push   $0x80111a00
8010173f:	e8 bc 30 00 00       	call   80104800 <acquire>
  ip->ref++;
80101744:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101748:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010174f:	e8 6c 31 00 00       	call   801048c0 <release>
}
80101754:	89 d8                	mov    %ebx,%eax
80101756:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101759:	c9                   	leave  
8010175a:	c3                   	ret    
8010175b:	90                   	nop
8010175c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101760 <ilock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	0f 84 b7 00 00 00    	je     80101827 <ilock+0xc7>
80101770:	8b 53 08             	mov    0x8(%ebx),%edx
80101773:	85 d2                	test   %edx,%edx
80101775:	0f 8e ac 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010177e:	83 ec 0c             	sub    $0xc,%esp
80101781:	50                   	push   %eax
80101782:	e8 49 2e 00 00       	call   801045d0 <acquiresleep>
  if(ip->valid == 0){
80101787:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178a:	83 c4 10             	add    $0x10,%esp
8010178d:	85 c0                	test   %eax,%eax
8010178f:	74 0f                	je     801017a0 <ilock+0x40>
}
80101791:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101794:	5b                   	pop    %ebx
80101795:	5e                   	pop    %esi
80101796:	5d                   	pop    %ebp
80101797:	c3                   	ret    
80101798:	90                   	nop
80101799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
801017b7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017b9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017bc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 c3 31 00 00       	call   801049c0 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 db e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 77 ff ff ff    	jne    80101791 <ilock+0x31>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 70 85 10 80       	push   $0x80108570
80101822:	e8 59 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 6a 85 10 80       	push   $0x8010856a
8010182f:	e8 4c eb ff ff       	call   80100380 <panic>
80101834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010183a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101840 <iunlock>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	56                   	push   %esi
80101844:	53                   	push   %ebx
80101845:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101848:	85 db                	test   %ebx,%ebx
8010184a:	74 28                	je     80101874 <iunlock+0x34>
8010184c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010184f:	83 ec 0c             	sub    $0xc,%esp
80101852:	56                   	push   %esi
80101853:	e8 18 2e 00 00       	call   80104670 <holdingsleep>
80101858:	83 c4 10             	add    $0x10,%esp
8010185b:	85 c0                	test   %eax,%eax
8010185d:	74 15                	je     80101874 <iunlock+0x34>
8010185f:	8b 43 08             	mov    0x8(%ebx),%eax
80101862:	85 c0                	test   %eax,%eax
80101864:	7e 0e                	jle    80101874 <iunlock+0x34>
  releasesleep(&ip->lock);
80101866:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101869:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010186c:	5b                   	pop    %ebx
8010186d:	5e                   	pop    %esi
8010186e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010186f:	e9 bc 2d 00 00       	jmp    80104630 <releasesleep>
    panic("iunlock");
80101874:	83 ec 0c             	sub    $0xc,%esp
80101877:	68 7f 85 10 80       	push   $0x8010857f
8010187c:	e8 ff ea ff ff       	call   80100380 <panic>
80101881:	eb 0d                	jmp    80101890 <iput>
80101883:	90                   	nop
80101884:	90                   	nop
80101885:	90                   	nop
80101886:	90                   	nop
80101887:	90                   	nop
80101888:	90                   	nop
80101889:	90                   	nop
8010188a:	90                   	nop
8010188b:	90                   	nop
8010188c:	90                   	nop
8010188d:	90                   	nop
8010188e:	90                   	nop
8010188f:	90                   	nop

80101890 <iput>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	57                   	push   %edi
80101894:	56                   	push   %esi
80101895:	53                   	push   %ebx
80101896:	83 ec 28             	sub    $0x28,%esp
80101899:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010189c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010189f:	57                   	push   %edi
801018a0:	e8 2b 2d 00 00       	call   801045d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018a8:	83 c4 10             	add    $0x10,%esp
801018ab:	85 d2                	test   %edx,%edx
801018ad:	74 07                	je     801018b6 <iput+0x26>
801018af:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b4:	74 32                	je     801018e8 <iput+0x58>
  releasesleep(&ip->lock);
801018b6:	83 ec 0c             	sub    $0xc,%esp
801018b9:	57                   	push   %edi
801018ba:	e8 71 2d 00 00       	call   80104630 <releasesleep>
  acquire(&icache.lock);
801018bf:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018c6:	e8 35 2f 00 00       	call   80104800 <acquire>
  ip->ref--;
801018cb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018cf:	83 c4 10             	add    $0x10,%esp
801018d2:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
801018d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018dc:	5b                   	pop    %ebx
801018dd:	5e                   	pop    %esi
801018de:	5f                   	pop    %edi
801018df:	5d                   	pop    %ebp
  release(&icache.lock);
801018e0:	e9 db 2f 00 00       	jmp    801048c0 <release>
801018e5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018e8:	83 ec 0c             	sub    $0xc,%esp
801018eb:	68 00 1a 11 80       	push   $0x80111a00
801018f0:	e8 0b 2f 00 00       	call   80104800 <acquire>
    int r = ip->ref;
801018f5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018f8:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018ff:	e8 bc 2f 00 00       	call   801048c0 <release>
    if(r == 1){
80101904:	83 c4 10             	add    $0x10,%esp
80101907:	83 fe 01             	cmp    $0x1,%esi
8010190a:	75 aa                	jne    801018b6 <iput+0x26>
8010190c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101912:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101915:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101918:	89 cf                	mov    %ecx,%edi
8010191a:	eb 0b                	jmp    80101927 <iput+0x97>
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101920:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101923:	39 fe                	cmp    %edi,%esi
80101925:	74 19                	je     80101940 <iput+0xb0>
    if(ip->addrs[i]){
80101927:	8b 16                	mov    (%esi),%edx
80101929:	85 d2                	test   %edx,%edx
8010192b:	74 f3                	je     80101920 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010192d:	8b 03                	mov    (%ebx),%eax
8010192f:	e8 bc f8 ff ff       	call   801011f0 <bfree>
      ip->addrs[i] = 0;
80101934:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010193a:	eb e4                	jmp    80101920 <iput+0x90>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101940:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101946:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101949:	85 c0                	test   %eax,%eax
8010194b:	75 33                	jne    80101980 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010194d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101950:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101957:	53                   	push   %ebx
80101958:	e8 53 fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
8010195d:	31 c0                	xor    %eax,%eax
8010195f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101963:	89 1c 24             	mov    %ebx,(%esp)
80101966:	e8 45 fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
8010196b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101972:	83 c4 10             	add    $0x10,%esp
80101975:	e9 3c ff ff ff       	jmp    801018b6 <iput+0x26>
8010197a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101980:	83 ec 08             	sub    $0x8,%esp
80101983:	50                   	push   %eax
80101984:	ff 33                	pushl  (%ebx)
80101986:	e8 45 e7 ff ff       	call   801000d0 <bread>
8010198b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101991:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101994:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101997:	8d 70 5c             	lea    0x5c(%eax),%esi
8010199a:	83 c4 10             	add    $0x10,%esp
8010199d:	89 cf                	mov    %ecx,%edi
8010199f:	eb 0e                	jmp    801019af <iput+0x11f>
801019a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019a8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801019ab:	39 fe                	cmp    %edi,%esi
801019ad:	74 0f                	je     801019be <iput+0x12e>
      if(a[j])
801019af:	8b 16                	mov    (%esi),%edx
801019b1:	85 d2                	test   %edx,%edx
801019b3:	74 f3                	je     801019a8 <iput+0x118>
        bfree(ip->dev, a[j]);
801019b5:	8b 03                	mov    (%ebx),%eax
801019b7:	e8 34 f8 ff ff       	call   801011f0 <bfree>
801019bc:	eb ea                	jmp    801019a8 <iput+0x118>
    brelse(bp);
801019be:	83 ec 0c             	sub    $0xc,%esp
801019c1:	ff 75 e4             	pushl  -0x1c(%ebp)
801019c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019c7:	e8 14 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019cc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019d2:	8b 03                	mov    (%ebx),%eax
801019d4:	e8 17 f8 ff ff       	call   801011f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019d9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019e0:	00 00 00 
801019e3:	83 c4 10             	add    $0x10,%esp
801019e6:	e9 62 ff ff ff       	jmp    8010194d <iput+0xbd>
801019eb:	90                   	nop
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019f0 <iunlockput>:
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	53                   	push   %ebx
801019f4:	83 ec 10             	sub    $0x10,%esp
801019f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019fa:	53                   	push   %ebx
801019fb:	e8 40 fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a00:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a03:	83 c4 10             	add    $0x10,%esp
}
80101a06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a09:	c9                   	leave  
  iput(ip);
80101a0a:	e9 81 fe ff ff       	jmp    80101890 <iput>
80101a0f:	90                   	nop

80101a10 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	8b 55 08             	mov    0x8(%ebp),%edx
80101a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a19:	8b 0a                	mov    (%edx),%ecx
80101a1b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a1e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a21:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a24:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a28:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a2b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a2f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a33:	8b 52 58             	mov    0x58(%edx),%edx
80101a36:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a40 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 1c             	sub    $0x1c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a57:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a60:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a63:	0f 84 a7 00 00 00    	je     80101b10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	8b 40 58             	mov    0x58(%eax),%eax
80101a6f:	39 c6                	cmp    %eax,%esi
80101a71:	0f 87 ba 00 00 00    	ja     80101b31 <readi+0xf1>
80101a77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a7a:	89 f9                	mov    %edi,%ecx
80101a7c:	01 f1                	add    %esi,%ecx
80101a7e:	0f 82 ad 00 00 00    	jb     80101b31 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a84:	89 c2                	mov    %eax,%edx
80101a86:	29 f2                	sub    %esi,%edx
80101a88:	39 c8                	cmp    %ecx,%eax
80101a8a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a8d:	31 ff                	xor    %edi,%edi
80101a8f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a91:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a94:	74 6c                	je     80101b02 <readi+0xc2>
80101a96:	8d 76 00             	lea    0x0(%esi),%esi
80101a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101aa3:	89 f2                	mov    %esi,%edx
80101aa5:	c1 ea 09             	shr    $0x9,%edx
80101aa8:	89 d8                	mov    %ebx,%eax
80101aaa:	e8 91 f9 ff ff       	call   80101440 <bmap>
80101aaf:	83 ec 08             	sub    $0x8,%esp
80101ab2:	50                   	push   %eax
80101ab3:	ff 33                	pushl  (%ebx)
80101ab5:	e8 16 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101abd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101abf:	89 f0                	mov    %esi,%eax
80101ac1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ac6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101acb:	83 c4 0c             	add    $0xc,%esp
80101ace:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ad0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101ad4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad7:	29 fb                	sub    %edi,%ebx
80101ad9:	39 d9                	cmp    %ebx,%ecx
80101adb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ade:	53                   	push   %ebx
80101adf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ae2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ae7:	e8 d4 2e 00 00       	call   801049c0 <memmove>
    brelse(bp);
80101aec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aef:	89 14 24             	mov    %edx,(%esp)
80101af2:	e8 e9 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b00:	77 9e                	ja     80101aa0 <readi+0x60>
  }
  return n;
80101b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b08:	5b                   	pop    %ebx
80101b09:	5e                   	pop    %esi
80101b0a:	5f                   	pop    %edi
80101b0b:	5d                   	pop    %ebp
80101b0c:	c3                   	ret    
80101b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b14:	66 83 f8 09          	cmp    $0x9,%ax
80101b18:	77 17                	ja     80101b31 <readi+0xf1>
80101b1a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101b21:	85 c0                	test   %eax,%eax
80101b23:	74 0c                	je     80101b31 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b2b:	5b                   	pop    %ebx
80101b2c:	5e                   	pop    %esi
80101b2d:	5f                   	pop    %edi
80101b2e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b2f:	ff e0                	jmp    *%eax
      return -1;
80101b31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b36:	eb cd                	jmp    80101b05 <readi+0xc5>
80101b38:	90                   	nop
80101b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	57                   	push   %edi
80101b44:	56                   	push   %esi
80101b45:	53                   	push   %ebx
80101b46:	83 ec 1c             	sub    $0x1c,%esp
80101b49:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b60:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b63:	0f 84 b7 00 00 00    	je     80101c20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b6f:	0f 82 eb 00 00 00    	jb     80101c60 <writei+0x120>
80101b75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b78:	31 d2                	xor    %edx,%edx
80101b7a:	89 f8                	mov    %edi,%eax
80101b7c:	01 f0                	add    %esi,%eax
80101b7e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b81:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b86:	0f 87 d4 00 00 00    	ja     80101c60 <writei+0x120>
80101b8c:	85 d2                	test   %edx,%edx
80101b8e:	0f 85 cc 00 00 00    	jne    80101c60 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b94:	85 ff                	test   %edi,%edi
80101b96:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b9d:	74 72                	je     80101c11 <writei+0xd1>
80101b9f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ba3:	89 f2                	mov    %esi,%edx
80101ba5:	c1 ea 09             	shr    $0x9,%edx
80101ba8:	89 f8                	mov    %edi,%eax
80101baa:	e8 91 f8 ff ff       	call   80101440 <bmap>
80101baf:	83 ec 08             	sub    $0x8,%esp
80101bb2:	50                   	push   %eax
80101bb3:	ff 37                	pushl  (%edi)
80101bb5:	e8 16 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bba:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bbd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bc2:	89 f0                	mov    %esi,%eax
80101bc4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bc9:	83 c4 0c             	add    $0xc,%esp
80101bcc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bd1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bd3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bd7:	39 d9                	cmp    %ebx,%ecx
80101bd9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bdc:	53                   	push   %ebx
80101bdd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101be2:	50                   	push   %eax
80101be3:	e8 d8 2d 00 00       	call   801049c0 <memmove>
    log_write(bp);
80101be8:	89 3c 24             	mov    %edi,(%esp)
80101beb:	e8 60 12 00 00       	call   80102e50 <log_write>
    brelse(bp);
80101bf0:	89 3c 24             	mov    %edi,(%esp)
80101bf3:	e8 e8 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bfb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bfe:	83 c4 10             	add    $0x10,%esp
80101c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c04:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c07:	77 97                	ja     80101ba0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c0c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c0f:	77 37                	ja     80101c48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c17:	5b                   	pop    %ebx
80101c18:	5e                   	pop    %esi
80101c19:	5f                   	pop    %edi
80101c1a:	5d                   	pop    %ebp
80101c1b:	c3                   	ret    
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c24:	66 83 f8 09          	cmp    $0x9,%ax
80101c28:	77 36                	ja     80101c60 <writei+0x120>
80101c2a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101c31:	85 c0                	test   %eax,%eax
80101c33:	74 2b                	je     80101c60 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101c35:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3b:	5b                   	pop    %ebx
80101c3c:	5e                   	pop    %esi
80101c3d:	5f                   	pop    %edi
80101c3e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c3f:	ff e0                	jmp    *%eax
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c4b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c51:	50                   	push   %eax
80101c52:	e8 59 fa ff ff       	call   801016b0 <iupdate>
80101c57:	83 c4 10             	add    $0x10,%esp
80101c5a:	eb b5                	jmp    80101c11 <writei+0xd1>
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c65:	eb ad                	jmp    80101c14 <writei+0xd4>
80101c67:	89 f6                	mov    %esi,%esi
80101c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c76:	6a 0e                	push   $0xe
80101c78:	ff 75 0c             	pushl  0xc(%ebp)
80101c7b:	ff 75 08             	pushl  0x8(%ebp)
80101c7e:	e8 ad 2d 00 00       	call   80104a30 <strncmp>
}
80101c83:	c9                   	leave  
80101c84:	c3                   	ret    
80101c85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	83 ec 1c             	sub    $0x1c,%esp
80101c99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ca1:	0f 85 85 00 00 00    	jne    80101d2c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ca7:	8b 53 58             	mov    0x58(%ebx),%edx
80101caa:	31 ff                	xor    %edi,%edi
80101cac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101caf:	85 d2                	test   %edx,%edx
80101cb1:	74 3e                	je     80101cf1 <dirlookup+0x61>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cb8:	6a 10                	push   $0x10
80101cba:	57                   	push   %edi
80101cbb:	56                   	push   %esi
80101cbc:	53                   	push   %ebx
80101cbd:	e8 7e fd ff ff       	call   80101a40 <readi>
80101cc2:	83 c4 10             	add    $0x10,%esp
80101cc5:	83 f8 10             	cmp    $0x10,%eax
80101cc8:	75 55                	jne    80101d1f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101cca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ccf:	74 18                	je     80101ce9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101cd1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cd4:	83 ec 04             	sub    $0x4,%esp
80101cd7:	6a 0e                	push   $0xe
80101cd9:	50                   	push   %eax
80101cda:	ff 75 0c             	pushl  0xc(%ebp)
80101cdd:	e8 4e 2d 00 00       	call   80104a30 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ce2:	83 c4 10             	add    $0x10,%esp
80101ce5:	85 c0                	test   %eax,%eax
80101ce7:	74 17                	je     80101d00 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ce9:	83 c7 10             	add    $0x10,%edi
80101cec:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101cef:	72 c7                	jb     80101cb8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cf4:	31 c0                	xor    %eax,%eax
}
80101cf6:	5b                   	pop    %ebx
80101cf7:	5e                   	pop    %esi
80101cf8:	5f                   	pop    %edi
80101cf9:	5d                   	pop    %ebp
80101cfa:	c3                   	ret    
80101cfb:	90                   	nop
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101d00:	8b 45 10             	mov    0x10(%ebp),%eax
80101d03:	85 c0                	test   %eax,%eax
80101d05:	74 05                	je     80101d0c <dirlookup+0x7c>
        *poff = off;
80101d07:	8b 45 10             	mov    0x10(%ebp),%eax
80101d0a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d0c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d10:	8b 03                	mov    (%ebx),%eax
80101d12:	e8 59 f6 ff ff       	call   80101370 <iget>
}
80101d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d1a:	5b                   	pop    %ebx
80101d1b:	5e                   	pop    %esi
80101d1c:	5f                   	pop    %edi
80101d1d:	5d                   	pop    %ebp
80101d1e:	c3                   	ret    
      panic("dirlookup read");
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	68 99 85 10 80       	push   $0x80108599
80101d27:	e8 54 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d2c:	83 ec 0c             	sub    $0xc,%esp
80101d2f:	68 87 85 10 80       	push   $0x80108587
80101d34:	e8 47 e6 ff ff       	call   80100380 <panic>
80101d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	89 cf                	mov    %ecx,%edi
80101d48:	89 c3                	mov    %eax,%ebx
80101d4a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d4d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d50:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d53:	0f 84 67 01 00 00    	je     80101ec0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d59:	e8 32 1b 00 00       	call   80103890 <myproc>
  acquire(&icache.lock);
80101d5e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d61:	8b 70 5c             	mov    0x5c(%eax),%esi
  acquire(&icache.lock);
80101d64:	68 00 1a 11 80       	push   $0x80111a00
80101d69:	e8 92 2a 00 00       	call   80104800 <acquire>
  ip->ref++;
80101d6e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d72:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101d79:	e8 42 2b 00 00       	call   801048c0 <release>
80101d7e:	83 c4 10             	add    $0x10,%esp
80101d81:	eb 08                	jmp    80101d8b <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d88:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d8b:	0f b6 03             	movzbl (%ebx),%eax
80101d8e:	3c 2f                	cmp    $0x2f,%al
80101d90:	74 f6                	je     80101d88 <namex+0x48>
  if(*path == 0)
80101d92:	84 c0                	test   %al,%al
80101d94:	0f 84 ee 00 00 00    	je     80101e88 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d9a:	0f b6 03             	movzbl (%ebx),%eax
80101d9d:	3c 2f                	cmp    $0x2f,%al
80101d9f:	0f 84 b3 00 00 00    	je     80101e58 <namex+0x118>
80101da5:	84 c0                	test   %al,%al
80101da7:	89 da                	mov    %ebx,%edx
80101da9:	75 09                	jne    80101db4 <namex+0x74>
80101dab:	e9 a8 00 00 00       	jmp    80101e58 <namex+0x118>
80101db0:	84 c0                	test   %al,%al
80101db2:	74 0a                	je     80101dbe <namex+0x7e>
    path++;
80101db4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101db7:	0f b6 02             	movzbl (%edx),%eax
80101dba:	3c 2f                	cmp    $0x2f,%al
80101dbc:	75 f2                	jne    80101db0 <namex+0x70>
80101dbe:	89 d1                	mov    %edx,%ecx
80101dc0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101dc2:	83 f9 0d             	cmp    $0xd,%ecx
80101dc5:	0f 8e 91 00 00 00    	jle    80101e5c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101dcb:	83 ec 04             	sub    $0x4,%esp
80101dce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101dd1:	6a 0e                	push   $0xe
80101dd3:	53                   	push   %ebx
80101dd4:	57                   	push   %edi
80101dd5:	e8 e6 2b 00 00       	call   801049c0 <memmove>
    path++;
80101dda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101ddd:	83 c4 10             	add    $0x10,%esp
    path++;
80101de0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101de2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101de5:	75 11                	jne    80101df8 <namex+0xb8>
80101de7:	89 f6                	mov    %esi,%esi
80101de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101df0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101df3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101df6:	74 f8                	je     80101df0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101df8:	83 ec 0c             	sub    $0xc,%esp
80101dfb:	56                   	push   %esi
80101dfc:	e8 5f f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e01:	83 c4 10             	add    $0x10,%esp
80101e04:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e09:	0f 85 91 00 00 00    	jne    80101ea0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e12:	85 d2                	test   %edx,%edx
80101e14:	74 09                	je     80101e1f <namex+0xdf>
80101e16:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e19:	0f 84 b7 00 00 00    	je     80101ed6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e1f:	83 ec 04             	sub    $0x4,%esp
80101e22:	6a 00                	push   $0x0
80101e24:	57                   	push   %edi
80101e25:	56                   	push   %esi
80101e26:	e8 65 fe ff ff       	call   80101c90 <dirlookup>
80101e2b:	83 c4 10             	add    $0x10,%esp
80101e2e:	85 c0                	test   %eax,%eax
80101e30:	74 6e                	je     80101ea0 <namex+0x160>
  iunlock(ip);
80101e32:	83 ec 0c             	sub    $0xc,%esp
80101e35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e38:	56                   	push   %esi
80101e39:	e8 02 fa ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e3e:	89 34 24             	mov    %esi,(%esp)
80101e41:	e8 4a fa ff ff       	call   80101890 <iput>
80101e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	89 c6                	mov    %eax,%esi
80101e4e:	e9 38 ff ff ff       	jmp    80101d8b <namex+0x4b>
80101e53:	90                   	nop
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e58:	89 da                	mov    %ebx,%edx
80101e5a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e5c:	83 ec 04             	sub    $0x4,%esp
80101e5f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e62:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e65:	51                   	push   %ecx
80101e66:	53                   	push   %ebx
80101e67:	57                   	push   %edi
80101e68:	e8 53 2b 00 00       	call   801049c0 <memmove>
    name[len] = 0;
80101e6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e70:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e73:	83 c4 10             	add    $0x10,%esp
80101e76:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e7a:	89 d3                	mov    %edx,%ebx
80101e7c:	e9 61 ff ff ff       	jmp    80101de2 <namex+0xa2>
80101e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e8b:	85 c0                	test   %eax,%eax
80101e8d:	75 5d                	jne    80101eec <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e92:	89 f0                	mov    %esi,%eax
80101e94:	5b                   	pop    %ebx
80101e95:	5e                   	pop    %esi
80101e96:	5f                   	pop    %edi
80101e97:	5d                   	pop    %ebp
80101e98:	c3                   	ret    
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
80101ea3:	56                   	push   %esi
80101ea4:	e8 97 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ea9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101eac:	31 f6                	xor    %esi,%esi
  iput(ip);
80101eae:	e8 dd f9 ff ff       	call   80101890 <iput>
      return 0;
80101eb3:	83 c4 10             	add    $0x10,%esp
}
80101eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb9:	89 f0                	mov    %esi,%eax
80101ebb:	5b                   	pop    %ebx
80101ebc:	5e                   	pop    %esi
80101ebd:	5f                   	pop    %edi
80101ebe:	5d                   	pop    %ebp
80101ebf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101ec0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ec5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eca:	e8 a1 f4 ff ff       	call   80101370 <iget>
80101ecf:	89 c6                	mov    %eax,%esi
80101ed1:	e9 b5 fe ff ff       	jmp    80101d8b <namex+0x4b>
      iunlock(ip);
80101ed6:	83 ec 0c             	sub    $0xc,%esp
80101ed9:	56                   	push   %esi
80101eda:	e8 61 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101edf:	83 c4 10             	add    $0x10,%esp
}
80101ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee5:	89 f0                	mov    %esi,%eax
80101ee7:	5b                   	pop    %ebx
80101ee8:	5e                   	pop    %esi
80101ee9:	5f                   	pop    %edi
80101eea:	5d                   	pop    %ebp
80101eeb:	c3                   	ret    
    iput(ip);
80101eec:	83 ec 0c             	sub    $0xc,%esp
80101eef:	56                   	push   %esi
    return 0;
80101ef0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ef2:	e8 99 f9 ff ff       	call   80101890 <iput>
    return 0;
80101ef7:	83 c4 10             	add    $0x10,%esp
80101efa:	eb 93                	jmp    80101e8f <namex+0x14f>
80101efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f00 <dirlink>:
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	83 ec 20             	sub    $0x20,%esp
80101f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f0c:	6a 00                	push   $0x0
80101f0e:	ff 75 0c             	pushl  0xc(%ebp)
80101f11:	53                   	push   %ebx
80101f12:	e8 79 fd ff ff       	call   80101c90 <dirlookup>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	85 c0                	test   %eax,%eax
80101f1c:	75 67                	jne    80101f85 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f24:	85 ff                	test   %edi,%edi
80101f26:	74 29                	je     80101f51 <dirlink+0x51>
80101f28:	31 ff                	xor    %edi,%edi
80101f2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f2d:	eb 09                	jmp    80101f38 <dirlink+0x38>
80101f2f:	90                   	nop
80101f30:	83 c7 10             	add    $0x10,%edi
80101f33:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f36:	73 19                	jae    80101f51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f38:	6a 10                	push   $0x10
80101f3a:	57                   	push   %edi
80101f3b:	56                   	push   %esi
80101f3c:	53                   	push   %ebx
80101f3d:	e8 fe fa ff ff       	call   80101a40 <readi>
80101f42:	83 c4 10             	add    $0x10,%esp
80101f45:	83 f8 10             	cmp    $0x10,%eax
80101f48:	75 4e                	jne    80101f98 <dirlink+0x98>
    if(de.inum == 0)
80101f4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f4f:	75 df                	jne    80101f30 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f54:	83 ec 04             	sub    $0x4,%esp
80101f57:	6a 0e                	push   $0xe
80101f59:	ff 75 0c             	pushl  0xc(%ebp)
80101f5c:	50                   	push   %eax
80101f5d:	e8 2e 2b 00 00       	call   80104a90 <strncpy>
  de.inum = inum;
80101f62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f65:	6a 10                	push   $0x10
80101f67:	57                   	push   %edi
80101f68:	56                   	push   %esi
80101f69:	53                   	push   %ebx
  de.inum = inum;
80101f6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f6e:	e8 cd fb ff ff       	call   80101b40 <writei>
80101f73:	83 c4 20             	add    $0x20,%esp
80101f76:	83 f8 10             	cmp    $0x10,%eax
80101f79:	75 2a                	jne    80101fa5 <dirlink+0xa5>
  return 0;
80101f7b:	31 c0                	xor    %eax,%eax
}
80101f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret    
    iput(ip);
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	50                   	push   %eax
80101f89:	e8 02 f9 ff ff       	call   80101890 <iput>
    return -1;
80101f8e:	83 c4 10             	add    $0x10,%esp
80101f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f96:	eb e5                	jmp    80101f7d <dirlink+0x7d>
      panic("dirlink read");
80101f98:	83 ec 0c             	sub    $0xc,%esp
80101f9b:	68 a8 85 10 80       	push   $0x801085a8
80101fa0:	e8 db e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80101fa5:	83 ec 0c             	sub    $0xc,%esp
80101fa8:	68 96 8b 10 80       	push   $0x80108b96
80101fad:	e8 ce e3 ff ff       	call   80100380 <panic>
80101fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <namei>:

struct inode*
namei(char *path)
{
80101fc0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fc1:	31 d2                	xor    %edx,%edx
{
80101fc3:	89 e5                	mov    %esp,%ebp
80101fc5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fce:	e8 6d fd ff ff       	call   80101d40 <namex>
}
80101fd3:	c9                   	leave  
80101fd4:	c3                   	ret    
80101fd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fe0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fe1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fe6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fee:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fef:	e9 4c fd ff ff       	jmp    80101d40 <namex>
80101ff4:	66 90                	xchg   %ax,%ax
80101ff6:	66 90                	xchg   %ax,%ax
80101ff8:	66 90                	xchg   %ax,%ax
80101ffa:	66 90                	xchg   %ax,%ax
80101ffc:	66 90                	xchg   %ax,%ax
80101ffe:	66 90                	xchg   %ax,%ax

80102000 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102009:	85 c0                	test   %eax,%eax
8010200b:	0f 84 b4 00 00 00    	je     801020c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102011:	8b 58 08             	mov    0x8(%eax),%ebx
80102014:	89 c6                	mov    %eax,%esi
80102016:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010201c:	0f 87 96 00 00 00    	ja     801020b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102027:	89 f6                	mov    %esi,%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102030:	89 ca                	mov    %ecx,%edx
80102032:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102033:	83 e0 c0             	and    $0xffffffc0,%eax
80102036:	3c 40                	cmp    $0x40,%al
80102038:	75 f6                	jne    80102030 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010203a:	31 ff                	xor    %edi,%edi
8010203c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102041:	89 f8                	mov    %edi,%eax
80102043:	ee                   	out    %al,(%dx)
80102044:	b8 01 00 00 00       	mov    $0x1,%eax
80102049:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010204e:	ee                   	out    %al,(%dx)
8010204f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102054:	89 d8                	mov    %ebx,%eax
80102056:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102057:	89 d8                	mov    %ebx,%eax
80102059:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010205e:	c1 f8 08             	sar    $0x8,%eax
80102061:	ee                   	out    %al,(%dx)
80102062:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102067:	89 f8                	mov    %edi,%eax
80102069:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010206a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010206e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102073:	c1 e0 04             	shl    $0x4,%eax
80102076:	83 e0 10             	and    $0x10,%eax
80102079:	83 c8 e0             	or     $0xffffffe0,%eax
8010207c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010207d:	f6 06 04             	testb  $0x4,(%esi)
80102080:	75 16                	jne    80102098 <idestart+0x98>
80102082:	b8 20 00 00 00       	mov    $0x20,%eax
80102087:	89 ca                	mov    %ecx,%edx
80102089:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010208a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208d:	5b                   	pop    %ebx
8010208e:	5e                   	pop    %esi
8010208f:	5f                   	pop    %edi
80102090:	5d                   	pop    %ebp
80102091:	c3                   	ret    
80102092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102098:	b8 30 00 00 00       	mov    $0x30,%eax
8010209d:	89 ca                	mov    %ecx,%edx
8010209f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020a5:	83 c6 5c             	add    $0x5c,%esi
801020a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ad:	fc                   	cld    
801020ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b3:	5b                   	pop    %ebx
801020b4:	5e                   	pop    %esi
801020b5:	5f                   	pop    %edi
801020b6:	5d                   	pop    %ebp
801020b7:	c3                   	ret    
    panic("incorrect blockno");
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	68 14 86 10 80       	push   $0x80108614
801020c0:	e8 bb e2 ff ff       	call   80100380 <panic>
    panic("idestart");
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	68 0b 86 10 80       	push   $0x8010860b
801020cd:	e8 ae e2 ff ff       	call   80100380 <panic>
801020d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020e0 <ideinit>:
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020e6:	68 26 86 10 80       	push   $0x80108626
801020eb:	68 a0 b5 10 80       	push   $0x8010b5a0
801020f0:	e8 cb 25 00 00       	call   801046c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020f5:	58                   	pop    %eax
801020f6:	a1 40 3d 11 80       	mov    0x80113d40,%eax
801020fb:	5a                   	pop    %edx
801020fc:	83 e8 01             	sub    $0x1,%eax
801020ff:	50                   	push   %eax
80102100:	6a 0e                	push   $0xe
80102102:	e8 a9 02 00 00       	call   801023b0 <ioapicenable>
80102107:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010210a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010210f:	90                   	nop
80102110:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102111:	83 e0 c0             	and    $0xffffffc0,%eax
80102114:	3c 40                	cmp    $0x40,%al
80102116:	75 f8                	jne    80102110 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102118:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010211d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102122:	ee                   	out    %al,(%dx)
80102123:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102128:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010212d:	eb 06                	jmp    80102135 <ideinit+0x55>
8010212f:	90                   	nop
  for(i=0; i<1000; i++){
80102130:	83 e9 01             	sub    $0x1,%ecx
80102133:	74 0f                	je     80102144 <ideinit+0x64>
80102135:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102136:	84 c0                	test   %al,%al
80102138:	74 f6                	je     80102130 <ideinit+0x50>
      havedisk1 = 1;
8010213a:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80102141:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102144:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102149:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010214e:	ee                   	out    %al,(%dx)
}
8010214f:	c9                   	leave  
80102150:	c3                   	ret    
80102151:	eb 0d                	jmp    80102160 <ideintr>
80102153:	90                   	nop
80102154:	90                   	nop
80102155:	90                   	nop
80102156:	90                   	nop
80102157:	90                   	nop
80102158:	90                   	nop
80102159:	90                   	nop
8010215a:	90                   	nop
8010215b:	90                   	nop
8010215c:	90                   	nop
8010215d:	90                   	nop
8010215e:	90                   	nop
8010215f:	90                   	nop

80102160 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102169:	68 a0 b5 10 80       	push   $0x8010b5a0
8010216e:	e8 8d 26 00 00       	call   80104800 <acquire>

  if((b = idequeue) == 0){
80102173:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
80102179:	83 c4 10             	add    $0x10,%esp
8010217c:	85 db                	test   %ebx,%ebx
8010217e:	74 67                	je     801021e7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102180:	8b 43 58             	mov    0x58(%ebx),%eax
80102183:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102188:	8b 3b                	mov    (%ebx),%edi
8010218a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102190:	75 31                	jne    801021c3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102192:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102197:	89 f6                	mov    %esi,%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801021a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021a1:	89 c6                	mov    %eax,%esi
801021a3:	83 e6 c0             	and    $0xffffffc0,%esi
801021a6:	89 f1                	mov    %esi,%ecx
801021a8:	80 f9 40             	cmp    $0x40,%cl
801021ab:	75 f3                	jne    801021a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021ad:	a8 21                	test   $0x21,%al
801021af:	75 12                	jne    801021c3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801021b1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021b4:	b9 80 00 00 00       	mov    $0x80,%ecx
801021b9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021be:	fc                   	cld    
801021bf:	f3 6d                	rep insl (%dx),%es:(%edi)
801021c1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021c3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801021c6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021c9:	89 f9                	mov    %edi,%ecx
801021cb:	83 c9 02             	or     $0x2,%ecx
801021ce:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801021d0:	53                   	push   %ebx
801021d1:	e8 8a 1f 00 00       	call   80104160 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021d6:	a1 84 b5 10 80       	mov    0x8010b584,%eax
801021db:	83 c4 10             	add    $0x10,%esp
801021de:	85 c0                	test   %eax,%eax
801021e0:	74 05                	je     801021e7 <ideintr+0x87>
    idestart(idequeue);
801021e2:	e8 19 fe ff ff       	call   80102000 <idestart>
    release(&idelock);
801021e7:	83 ec 0c             	sub    $0xc,%esp
801021ea:	68 a0 b5 10 80       	push   $0x8010b5a0
801021ef:	e8 cc 26 00 00       	call   801048c0 <release>

  release(&idelock);
}
801021f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f7:	5b                   	pop    %ebx
801021f8:	5e                   	pop    %esi
801021f9:	5f                   	pop    %edi
801021fa:	5d                   	pop    %ebp
801021fb:	c3                   	ret    
801021fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102200 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	53                   	push   %ebx
80102204:	83 ec 10             	sub    $0x10,%esp
80102207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010220a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010220d:	50                   	push   %eax
8010220e:	e8 5d 24 00 00       	call   80104670 <holdingsleep>
80102213:	83 c4 10             	add    $0x10,%esp
80102216:	85 c0                	test   %eax,%eax
80102218:	0f 84 c6 00 00 00    	je     801022e4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010221e:	8b 03                	mov    (%ebx),%eax
80102220:	83 e0 06             	and    $0x6,%eax
80102223:	83 f8 02             	cmp    $0x2,%eax
80102226:	0f 84 ab 00 00 00    	je     801022d7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010222c:	8b 53 04             	mov    0x4(%ebx),%edx
8010222f:	85 d2                	test   %edx,%edx
80102231:	74 0d                	je     80102240 <iderw+0x40>
80102233:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80102238:	85 c0                	test   %eax,%eax
8010223a:	0f 84 b1 00 00 00    	je     801022f1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102240:	83 ec 0c             	sub    $0xc,%esp
80102243:	68 a0 b5 10 80       	push   $0x8010b5a0
80102248:	e8 b3 25 00 00       	call   80104800 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010224d:	8b 15 84 b5 10 80    	mov    0x8010b584,%edx
80102253:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102256:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010225d:	85 d2                	test   %edx,%edx
8010225f:	75 09                	jne    8010226a <iderw+0x6a>
80102261:	eb 6d                	jmp    801022d0 <iderw+0xd0>
80102263:	90                   	nop
80102264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102268:	89 c2                	mov    %eax,%edx
8010226a:	8b 42 58             	mov    0x58(%edx),%eax
8010226d:	85 c0                	test   %eax,%eax
8010226f:	75 f7                	jne    80102268 <iderw+0x68>
80102271:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102274:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102276:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
8010227c:	74 42                	je     801022c0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010227e:	8b 03                	mov    (%ebx),%eax
80102280:	83 e0 06             	and    $0x6,%eax
80102283:	83 f8 02             	cmp    $0x2,%eax
80102286:	74 23                	je     801022ab <iderw+0xab>
80102288:	90                   	nop
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102290:	83 ec 08             	sub    $0x8,%esp
80102293:	68 a0 b5 10 80       	push   $0x8010b5a0
80102298:	53                   	push   %ebx
80102299:	e8 62 1a 00 00       	call   80103d00 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010229e:	8b 03                	mov    (%ebx),%eax
801022a0:	83 c4 10             	add    $0x10,%esp
801022a3:	83 e0 06             	and    $0x6,%eax
801022a6:	83 f8 02             	cmp    $0x2,%eax
801022a9:	75 e5                	jne    80102290 <iderw+0x90>
  }


  release(&idelock);
801022ab:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
801022b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022b5:	c9                   	leave  
  release(&idelock);
801022b6:	e9 05 26 00 00       	jmp    801048c0 <release>
801022bb:	90                   	nop
801022bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801022c0:	89 d8                	mov    %ebx,%eax
801022c2:	e8 39 fd ff ff       	call   80102000 <idestart>
801022c7:	eb b5                	jmp    8010227e <iderw+0x7e>
801022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d0:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
801022d5:	eb 9d                	jmp    80102274 <iderw+0x74>
    panic("iderw: nothing to do");
801022d7:	83 ec 0c             	sub    $0xc,%esp
801022da:	68 40 86 10 80       	push   $0x80108640
801022df:	e8 9c e0 ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 2a 86 10 80       	push   $0x8010862a
801022ec:	e8 8f e0 ff ff       	call   80100380 <panic>
    panic("iderw: ide disk 1 not present");
801022f1:	83 ec 0c             	sub    $0xc,%esp
801022f4:	68 55 86 10 80       	push   $0x80108655
801022f9:	e8 82 e0 ff ff       	call   80100380 <panic>
801022fe:	66 90                	xchg   %ax,%ax

80102300 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102300:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102301:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102308:	00 c0 fe 
{
8010230b:	89 e5                	mov    %esp,%ebp
8010230d:	56                   	push   %esi
8010230e:	53                   	push   %ebx
  ioapic->reg = reg;
8010230f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102316:	00 00 00 
  return ioapic->data;
80102319:	a1 54 36 11 80       	mov    0x80113654,%eax
8010231e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102327:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010232d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102334:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102337:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010233a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010233d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102340:	39 c2                	cmp    %eax,%edx
80102342:	74 16                	je     8010235a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102344:	83 ec 0c             	sub    $0xc,%esp
80102347:	68 74 86 10 80       	push   $0x80108674
8010234c:	e8 ff e2 ff ff       	call   80100650 <cprintf>
80102351:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102357:	83 c4 10             	add    $0x10,%esp
8010235a:	83 c3 21             	add    $0x21,%ebx
{
8010235d:	ba 10 00 00 00       	mov    $0x10,%edx
80102362:	b8 20 00 00 00       	mov    $0x20,%eax
80102367:	89 f6                	mov    %esi,%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102370:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102372:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102378:	89 c6                	mov    %eax,%esi
8010237a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102380:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102383:	89 71 10             	mov    %esi,0x10(%ecx)
80102386:	8d 72 01             	lea    0x1(%edx),%esi
80102389:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010238c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010238e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102390:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102396:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010239d:	75 d1                	jne    80102370 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010239f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a2:	5b                   	pop    %ebx
801023a3:	5e                   	pop    %esi
801023a4:	5d                   	pop    %ebp
801023a5:	c3                   	ret    
801023a6:	8d 76 00             	lea    0x0(%esi),%esi
801023a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023b0:	55                   	push   %ebp
  ioapic->reg = reg;
801023b1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
801023b7:	89 e5                	mov    %esp,%ebp
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023bc:	8d 50 20             	lea    0x20(%eax),%edx
801023bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023c5:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023d6:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023de:	89 50 10             	mov    %edx,0x10(%eax)
}
801023e1:	5d                   	pop    %ebp
801023e2:	c3                   	ret    
801023e3:	66 90                	xchg   %ax,%ax
801023e5:	66 90                	xchg   %ax,%ax
801023e7:	66 90                	xchg   %ax,%ax
801023e9:	66 90                	xchg   %ax,%ax
801023eb:	66 90                	xchg   %ax,%ax
801023ed:	66 90                	xchg   %ax,%ax
801023ef:	90                   	nop

801023f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	53                   	push   %ebx
801023f4:	83 ec 04             	sub    $0x4,%esp
801023f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102400:	75 70                	jne    80102472 <kfree+0x82>
80102402:	81 fb e8 88 11 80    	cmp    $0x801188e8,%ebx
80102408:	72 68                	jb     80102472 <kfree+0x82>
8010240a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102410:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102415:	77 5b                	ja     80102472 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102417:	83 ec 04             	sub    $0x4,%esp
8010241a:	68 00 10 00 00       	push   $0x1000
8010241f:	6a 01                	push   $0x1
80102421:	53                   	push   %ebx
80102422:	e8 e9 24 00 00       	call   80104910 <memset>

  if(kmem.use_lock)
80102427:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	85 d2                	test   %edx,%edx
80102432:	75 2c                	jne    80102460 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102434:	a1 98 36 11 80       	mov    0x80113698,%eax
80102439:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010243b:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
80102440:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
80102446:	85 c0                	test   %eax,%eax
80102448:	75 06                	jne    80102450 <kfree+0x60>
    release(&kmem.lock);
}
8010244a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010244d:	c9                   	leave  
8010244e:	c3                   	ret    
8010244f:	90                   	nop
    release(&kmem.lock);
80102450:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010245a:	c9                   	leave  
    release(&kmem.lock);
8010245b:	e9 60 24 00 00       	jmp    801048c0 <release>
    acquire(&kmem.lock);
80102460:	83 ec 0c             	sub    $0xc,%esp
80102463:	68 60 36 11 80       	push   $0x80113660
80102468:	e8 93 23 00 00       	call   80104800 <acquire>
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	eb c2                	jmp    80102434 <kfree+0x44>
    panic("kfree");
80102472:	83 ec 0c             	sub    $0xc,%esp
80102475:	68 a6 86 10 80       	push   $0x801086a6
8010247a:	e8 01 df ff ff       	call   80100380 <panic>
8010247f:	90                   	nop

80102480 <freerange>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102488:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010248b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102491:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249d:	39 de                	cmp    %ebx,%esi
8010249f:	72 23                	jb     801024c4 <freerange+0x44>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024b7:	50                   	push   %eax
801024b8:	e8 33 ff ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	39 f3                	cmp    %esi,%ebx
801024c2:	76 e4                	jbe    801024a8 <freerange+0x28>
}
801024c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c7:	5b                   	pop    %ebx
801024c8:	5e                   	pop    %esi
801024c9:	5d                   	pop    %ebp
801024ca:	c3                   	ret    
801024cb:	90                   	nop
801024cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024d0 <kinit1>:
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	56                   	push   %esi
801024d4:	53                   	push   %ebx
801024d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024d8:	83 ec 08             	sub    $0x8,%esp
801024db:	68 ac 86 10 80       	push   $0x801086ac
801024e0:	68 60 36 11 80       	push   $0x80113660
801024e5:	e8 d6 21 00 00       	call   801046c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801024f0:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
801024f7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801024fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102500:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102506:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010250c:	39 de                	cmp    %ebx,%esi
8010250e:	72 1c                	jb     8010252c <kinit1+0x5c>
    kfree(p);
80102510:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102516:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102519:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010251f:	50                   	push   %eax
80102520:	e8 cb fe ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102525:	83 c4 10             	add    $0x10,%esp
80102528:	39 de                	cmp    %ebx,%esi
8010252a:	73 e4                	jae    80102510 <kinit1+0x40>
}
8010252c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010252f:	5b                   	pop    %ebx
80102530:	5e                   	pop    %esi
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret    
80102533:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102540 <kinit2>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102548:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <kinit2+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010256e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 73 fe ff ff       	call   801023f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <kinit2+0x28>
  kmem.use_lock = 1;
80102584:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
8010258b:	00 00 00 
}
8010258e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102591:	5b                   	pop    %ebx
80102592:	5e                   	pop    %esi
80102593:	5d                   	pop    %ebp
80102594:	c3                   	ret    
80102595:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025a0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801025a0:	a1 94 36 11 80       	mov    0x80113694,%eax
801025a5:	85 c0                	test   %eax,%eax
801025a7:	75 1f                	jne    801025c8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025a9:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
801025ae:	85 c0                	test   %eax,%eax
801025b0:	74 0e                	je     801025c0 <kalloc+0x20>
    kmem.freelist = r->next;
801025b2:	8b 10                	mov    (%eax),%edx
801025b4:	89 15 98 36 11 80    	mov    %edx,0x80113698
801025ba:	c3                   	ret    
801025bb:	90                   	nop
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801025c0:	f3 c3                	repz ret 
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801025c8:	55                   	push   %ebp
801025c9:	89 e5                	mov    %esp,%ebp
801025cb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801025ce:	68 60 36 11 80       	push   $0x80113660
801025d3:	e8 28 22 00 00       	call   80104800 <acquire>
  r = kmem.freelist;
801025d8:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	8b 15 94 36 11 80    	mov    0x80113694,%edx
801025e6:	85 c0                	test   %eax,%eax
801025e8:	74 08                	je     801025f2 <kalloc+0x52>
    kmem.freelist = r->next;
801025ea:	8b 08                	mov    (%eax),%ecx
801025ec:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
801025f2:	85 d2                	test   %edx,%edx
801025f4:	74 16                	je     8010260c <kalloc+0x6c>
    release(&kmem.lock);
801025f6:	83 ec 0c             	sub    $0xc,%esp
801025f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801025fc:	68 60 36 11 80       	push   $0x80113660
80102601:	e8 ba 22 00 00       	call   801048c0 <release>
  return (char*)r;
80102606:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102609:	83 c4 10             	add    $0x10,%esp
}
8010260c:	c9                   	leave  
8010260d:	c3                   	ret    
8010260e:	66 90                	xchg   %ax,%ax

80102610 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102610:	ba 64 00 00 00       	mov    $0x64,%edx
80102615:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102616:	a8 01                	test   $0x1,%al
80102618:	0f 84 c2 00 00 00    	je     801026e0 <kbdgetc+0xd0>
8010261e:	ba 60 00 00 00       	mov    $0x60,%edx
80102623:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102624:	0f b6 d0             	movzbl %al,%edx
80102627:	8b 0d d4 b5 10 80    	mov    0x8010b5d4,%ecx

  if(data == 0xE0){
8010262d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102633:	0f 84 7f 00 00 00    	je     801026b8 <kbdgetc+0xa8>
{
80102639:	55                   	push   %ebp
8010263a:	89 e5                	mov    %esp,%ebp
8010263c:	53                   	push   %ebx
8010263d:	89 cb                	mov    %ecx,%ebx
8010263f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102642:	84 c0                	test   %al,%al
80102644:	78 4a                	js     80102690 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102646:	85 db                	test   %ebx,%ebx
80102648:	74 09                	je     80102653 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010264a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010264d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102650:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102653:	0f b6 82 e0 87 10 80 	movzbl -0x7fef7820(%edx),%eax
8010265a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010265c:	0f b6 82 e0 86 10 80 	movzbl -0x7fef7920(%edx),%eax
80102663:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102665:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102667:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
8010266d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102670:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102673:	8b 04 85 c0 86 10 80 	mov    -0x7fef7940(,%eax,4),%eax
8010267a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010267e:	74 31                	je     801026b1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102680:	8d 50 9f             	lea    -0x61(%eax),%edx
80102683:	83 fa 19             	cmp    $0x19,%edx
80102686:	77 40                	ja     801026c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102688:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010268b:	5b                   	pop    %ebx
8010268c:	5d                   	pop    %ebp
8010268d:	c3                   	ret    
8010268e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102690:	83 e0 7f             	and    $0x7f,%eax
80102693:	85 db                	test   %ebx,%ebx
80102695:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102698:	0f b6 82 e0 87 10 80 	movzbl -0x7fef7820(%edx),%eax
8010269f:	83 c8 40             	or     $0x40,%eax
801026a2:	0f b6 c0             	movzbl %al,%eax
801026a5:	f7 d0                	not    %eax
801026a7:	21 c1                	and    %eax,%ecx
    return 0;
801026a9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026ab:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
801026b1:	5b                   	pop    %ebx
801026b2:	5d                   	pop    %ebp
801026b3:	c3                   	ret    
801026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801026b8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801026bb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026bd:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
    return 0;
801026c3:	c3                   	ret    
801026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801026c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801026ce:	5b                   	pop    %ebx
      c += 'a' - 'A';
801026cf:	83 f9 1a             	cmp    $0x1a,%ecx
801026d2:	0f 42 c2             	cmovb  %edx,%eax
}
801026d5:	5d                   	pop    %ebp
801026d6:	c3                   	ret    
801026d7:	89 f6                	mov    %esi,%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801026e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801026e5:	c3                   	ret    
801026e6:	8d 76 00             	lea    0x0(%esi),%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026f0 <kbdintr>:

void
kbdintr(void)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801026f6:	68 10 26 10 80       	push   $0x80102610
801026fb:	e8 00 e1 ff ff       	call   80100800 <consoleintr>
}
80102700:	83 c4 10             	add    $0x10,%esp
80102703:	c9                   	leave  
80102704:	c3                   	ret    
80102705:	66 90                	xchg   %ax,%ax
80102707:	66 90                	xchg   %ax,%ax
80102709:	66 90                	xchg   %ax,%ax
8010270b:	66 90                	xchg   %ax,%ax
8010270d:	66 90                	xchg   %ax,%ax
8010270f:	90                   	nop

80102710 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102710:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102715:	55                   	push   %ebp
80102716:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102718:	85 c0                	test   %eax,%eax
8010271a:	0f 84 c8 00 00 00    	je     801027e8 <lapicinit+0xd8>
  lapic[index] = value;
80102720:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102727:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010272d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102734:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102737:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102741:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102744:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102747:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010274e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102751:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102754:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010275b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010275e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102761:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102768:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010276b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010276e:	8b 50 30             	mov    0x30(%eax),%edx
80102771:	c1 ea 10             	shr    $0x10,%edx
80102774:	80 fa 03             	cmp    $0x3,%dl
80102777:	77 77                	ja     801027f0 <lapicinit+0xe0>
  lapic[index] = value;
80102779:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102780:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102783:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102786:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010278d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102790:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102793:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010279a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010279d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027c4:	8b 50 20             	mov    0x20(%eax),%edx
801027c7:	89 f6                	mov    %esi,%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027d6:	80 e6 10             	and    $0x10,%dh
801027d9:	75 f5                	jne    801027d0 <lapicinit+0xc0>
  lapic[index] = value;
801027db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027e8:	5d                   	pop    %ebp
801027e9:	c3                   	ret    
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801027f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fa:	8b 50 20             	mov    0x20(%eax),%edx
801027fd:	e9 77 ff ff ff       	jmp    80102779 <lapicinit+0x69>
80102802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102810 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102810:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
{
80102816:	55                   	push   %ebp
80102817:	31 c0                	xor    %eax,%eax
80102819:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010281b:	85 d2                	test   %edx,%edx
8010281d:	74 06                	je     80102825 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010281f:	8b 42 20             	mov    0x20(%edx),%eax
80102822:	c1 e8 18             	shr    $0x18,%eax
}
80102825:	5d                   	pop    %ebp
80102826:	c3                   	ret    
80102827:	89 f6                	mov    %esi,%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102830 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102830:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102835:	55                   	push   %ebp
80102836:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102838:	85 c0                	test   %eax,%eax
8010283a:	74 0d                	je     80102849 <lapiceoi+0x19>
  lapic[index] = value;
8010283c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102843:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102846:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102849:	5d                   	pop    %ebp
8010284a:	c3                   	ret    
8010284b:	90                   	nop
8010284c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102850 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
}
80102853:	5d                   	pop    %ebp
80102854:	c3                   	ret    
80102855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102860:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102861:	b8 0f 00 00 00       	mov    $0xf,%eax
80102866:	ba 70 00 00 00       	mov    $0x70,%edx
8010286b:	89 e5                	mov    %esp,%ebp
8010286d:	53                   	push   %ebx
8010286e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102871:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102874:	ee                   	out    %al,(%dx)
80102875:	b8 0a 00 00 00       	mov    $0xa,%eax
8010287a:	ba 71 00 00 00       	mov    $0x71,%edx
8010287f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102880:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102882:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102885:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010288b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010288d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102890:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102893:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102895:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102898:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010289e:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801028a3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028ac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028b3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028b9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028c0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028c6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028cc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028cf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028d8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801028ea:	5b                   	pop    %ebx
801028eb:	5d                   	pop    %ebp
801028ec:	c3                   	ret    
801028ed:	8d 76 00             	lea    0x0(%esi),%esi

801028f0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801028f0:	55                   	push   %ebp
801028f1:	b8 0b 00 00 00       	mov    $0xb,%eax
801028f6:	ba 70 00 00 00       	mov    $0x70,%edx
801028fb:	89 e5                	mov    %esp,%ebp
801028fd:	57                   	push   %edi
801028fe:	56                   	push   %esi
801028ff:	53                   	push   %ebx
80102900:	83 ec 4c             	sub    $0x4c,%esp
80102903:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102904:	ba 71 00 00 00       	mov    $0x71,%edx
80102909:	ec                   	in     (%dx),%al
8010290a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010290d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102912:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102915:	8d 76 00             	lea    0x0(%esi),%esi
80102918:	31 c0                	xor    %eax,%eax
8010291a:	89 da                	mov    %ebx,%edx
8010291c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102922:	89 ca                	mov    %ecx,%edx
80102924:	ec                   	in     (%dx),%al
80102925:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102928:	89 da                	mov    %ebx,%edx
8010292a:	b8 02 00 00 00       	mov    $0x2,%eax
8010292f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102930:	89 ca                	mov    %ecx,%edx
80102932:	ec                   	in     (%dx),%al
80102933:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102936:	89 da                	mov    %ebx,%edx
80102938:	b8 04 00 00 00       	mov    $0x4,%eax
8010293d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293e:	89 ca                	mov    %ecx,%edx
80102940:	ec                   	in     (%dx),%al
80102941:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102944:	89 da                	mov    %ebx,%edx
80102946:	b8 07 00 00 00       	mov    $0x7,%eax
8010294b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294c:	89 ca                	mov    %ecx,%edx
8010294e:	ec                   	in     (%dx),%al
8010294f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102952:	89 da                	mov    %ebx,%edx
80102954:	b8 08 00 00 00       	mov    $0x8,%eax
80102959:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295a:	89 ca                	mov    %ecx,%edx
8010295c:	ec                   	in     (%dx),%al
8010295d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010295f:	89 da                	mov    %ebx,%edx
80102961:	b8 09 00 00 00       	mov    $0x9,%eax
80102966:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102967:	89 ca                	mov    %ecx,%edx
80102969:	ec                   	in     (%dx),%al
8010296a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010296c:	89 da                	mov    %ebx,%edx
8010296e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102973:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102974:	89 ca                	mov    %ecx,%edx
80102976:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102977:	84 c0                	test   %al,%al
80102979:	78 9d                	js     80102918 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010297b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010297f:	89 fa                	mov    %edi,%edx
80102981:	0f b6 fa             	movzbl %dl,%edi
80102984:	89 f2                	mov    %esi,%edx
80102986:	0f b6 f2             	movzbl %dl,%esi
80102989:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010298c:	89 da                	mov    %ebx,%edx
8010298e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102991:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102994:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102998:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010299b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010299f:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029a2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801029a6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029a9:	31 c0                	xor    %eax,%eax
801029ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ac:	89 ca                	mov    %ecx,%edx
801029ae:	ec                   	in     (%dx),%al
801029af:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b2:	89 da                	mov    %ebx,%edx
801029b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029b7:	b8 02 00 00 00       	mov    $0x2,%eax
801029bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bd:	89 ca                	mov    %ecx,%edx
801029bf:	ec                   	in     (%dx),%al
801029c0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c3:	89 da                	mov    %ebx,%edx
801029c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801029c8:	b8 04 00 00 00       	mov    $0x4,%eax
801029cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ce:	89 ca                	mov    %ecx,%edx
801029d0:	ec                   	in     (%dx),%al
801029d1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d4:	89 da                	mov    %ebx,%edx
801029d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029d9:	b8 07 00 00 00       	mov    $0x7,%eax
801029de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029df:	89 ca                	mov    %ecx,%edx
801029e1:	ec                   	in     (%dx),%al
801029e2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e5:	89 da                	mov    %ebx,%edx
801029e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029ea:	b8 08 00 00 00       	mov    $0x8,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 da                	mov    %ebx,%edx
801029f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801029fb:	b8 09 00 00 00       	mov    $0x9,%eax
80102a00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a01:	89 ca                	mov    %ecx,%edx
80102a03:	ec                   	in     (%dx),%al
80102a04:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a07:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a0d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a10:	6a 18                	push   $0x18
80102a12:	50                   	push   %eax
80102a13:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a16:	50                   	push   %eax
80102a17:	e8 44 1f 00 00       	call   80104960 <memcmp>
80102a1c:	83 c4 10             	add    $0x10,%esp
80102a1f:	85 c0                	test   %eax,%eax
80102a21:	0f 85 f1 fe ff ff    	jne    80102918 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a27:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a2b:	75 78                	jne    80102aa5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a30:	89 c2                	mov    %eax,%edx
80102a32:	83 e0 0f             	and    $0xf,%eax
80102a35:	c1 ea 04             	shr    $0x4,%edx
80102a38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a41:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a44:	89 c2                	mov    %eax,%edx
80102a46:	83 e0 0f             	and    $0xf,%eax
80102a49:	c1 ea 04             	shr    $0x4,%edx
80102a4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a52:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a55:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a58:	89 c2                	mov    %eax,%edx
80102a5a:	83 e0 0f             	and    $0xf,%eax
80102a5d:	c1 ea 04             	shr    $0x4,%edx
80102a60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a66:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a6c:	89 c2                	mov    %eax,%edx
80102a6e:	83 e0 0f             	and    $0xf,%eax
80102a71:	c1 ea 04             	shr    $0x4,%edx
80102a74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a80:	89 c2                	mov    %eax,%edx
80102a82:	83 e0 0f             	and    $0xf,%eax
80102a85:	c1 ea 04             	shr    $0x4,%edx
80102a88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a94:	89 c2                	mov    %eax,%edx
80102a96:	83 e0 0f             	and    $0xf,%eax
80102a99:	c1 ea 04             	shr    $0x4,%edx
80102a9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aa2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102aa5:	8b 75 08             	mov    0x8(%ebp),%esi
80102aa8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102aab:	89 06                	mov    %eax,(%esi)
80102aad:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ab0:	89 46 04             	mov    %eax,0x4(%esi)
80102ab3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ab6:	89 46 08             	mov    %eax,0x8(%esi)
80102ab9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102abc:	89 46 0c             	mov    %eax,0xc(%esi)
80102abf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ac2:	89 46 10             	mov    %eax,0x10(%esi)
80102ac5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ac8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102acb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ad2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ad5:	5b                   	pop    %ebx
80102ad6:	5e                   	pop    %esi
80102ad7:	5f                   	pop    %edi
80102ad8:	5d                   	pop    %ebp
80102ad9:	c3                   	ret    
80102ada:	66 90                	xchg   %ax,%ax
80102adc:	66 90                	xchg   %ax,%ax
80102ade:	66 90                	xchg   %ax,%ax

80102ae0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ae0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102ae6:	85 c9                	test   %ecx,%ecx
80102ae8:	0f 8e 8a 00 00 00    	jle    80102b78 <install_trans+0x98>
{
80102aee:	55                   	push   %ebp
80102aef:	89 e5                	mov    %esp,%ebp
80102af1:	57                   	push   %edi
80102af2:	56                   	push   %esi
80102af3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102af4:	31 db                	xor    %ebx,%ebx
{
80102af6:	83 ec 0c             	sub    $0xc,%esp
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b00:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102b05:	83 ec 08             	sub    $0x8,%esp
80102b08:	01 d8                	add    %ebx,%eax
80102b0a:	83 c0 01             	add    $0x1,%eax
80102b0d:	50                   	push   %eax
80102b0e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102b14:	e8 b7 d5 ff ff       	call   801000d0 <bread>
80102b19:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b1b:	58                   	pop    %eax
80102b1c:	5a                   	pop    %edx
80102b1d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102b24:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b2a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b2d:	e8 9e d5 ff ff       	call   801000d0 <bread>
80102b32:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b34:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b37:	83 c4 0c             	add    $0xc,%esp
80102b3a:	68 00 02 00 00       	push   $0x200
80102b3f:	50                   	push   %eax
80102b40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b43:	50                   	push   %eax
80102b44:	e8 77 1e 00 00       	call   801049c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b49:	89 34 24             	mov    %esi,(%esp)
80102b4c:	e8 4f d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102b51:	89 3c 24             	mov    %edi,(%esp)
80102b54:	e8 87 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102b59:	89 34 24             	mov    %esi,(%esp)
80102b5c:	e8 7f d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b61:	83 c4 10             	add    $0x10,%esp
80102b64:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102b6a:	7f 94                	jg     80102b00 <install_trans+0x20>
  }
}
80102b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b6f:	5b                   	pop    %ebx
80102b70:	5e                   	pop    %esi
80102b71:	5f                   	pop    %edi
80102b72:	5d                   	pop    %ebp
80102b73:	c3                   	ret    
80102b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b78:	f3 c3                	repz ret 
80102b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	56                   	push   %esi
80102b84:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102b85:	83 ec 08             	sub    $0x8,%esp
80102b88:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102b8e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102b94:	e8 37 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b99:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b9f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ba2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ba4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ba6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ba9:	7e 16                	jle    80102bc1 <write_head+0x41>
80102bab:	c1 e3 02             	shl    $0x2,%ebx
80102bae:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102bb0:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102bb6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102bba:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102bbd:	39 da                	cmp    %ebx,%edx
80102bbf:	75 ef                	jne    80102bb0 <write_head+0x30>
  }
  bwrite(buf);
80102bc1:	83 ec 0c             	sub    $0xc,%esp
80102bc4:	56                   	push   %esi
80102bc5:	e8 d6 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102bca:	89 34 24             	mov    %esi,(%esp)
80102bcd:	e8 0e d6 ff ff       	call   801001e0 <brelse>
}
80102bd2:	83 c4 10             	add    $0x10,%esp
80102bd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bd8:	5b                   	pop    %ebx
80102bd9:	5e                   	pop    %esi
80102bda:	5d                   	pop    %ebp
80102bdb:	c3                   	ret    
80102bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102be0 <initlog>:
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	53                   	push   %ebx
80102be4:	83 ec 2c             	sub    $0x2c,%esp
80102be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102bea:	68 e0 88 10 80       	push   $0x801088e0
80102bef:	68 a0 36 11 80       	push   $0x801136a0
80102bf4:	e8 c7 1a 00 00       	call   801046c0 <initlock>
  readsb(dev, &sb);
80102bf9:	58                   	pop    %eax
80102bfa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102bfd:	5a                   	pop    %edx
80102bfe:	50                   	push   %eax
80102bff:	53                   	push   %ebx
80102c00:	e8 1b e9 ff ff       	call   80101520 <readsb>
  log.size = sb.nlog;
80102c05:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c0b:	59                   	pop    %ecx
  log.dev = dev;
80102c0c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102c12:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102c18:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
80102c1d:	5a                   	pop    %edx
80102c1e:	50                   	push   %eax
80102c1f:	53                   	push   %ebx
80102c20:	e8 ab d4 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102c25:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c28:	83 c4 10             	add    $0x10,%esp
80102c2b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102c2d:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102c33:	7e 1c                	jle    80102c51 <initlog+0x71>
80102c35:	c1 e3 02             	shl    $0x2,%ebx
80102c38:	31 d2                	xor    %edx,%edx
80102c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102c40:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102c44:	83 c2 04             	add    $0x4,%edx
80102c47:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102c4d:	39 d3                	cmp    %edx,%ebx
80102c4f:	75 ef                	jne    80102c40 <initlog+0x60>
  brelse(buf);
80102c51:	83 ec 0c             	sub    $0xc,%esp
80102c54:	50                   	push   %eax
80102c55:	e8 86 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c5a:	e8 81 fe ff ff       	call   80102ae0 <install_trans>
  log.lh.n = 0;
80102c5f:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102c66:	00 00 00 
  write_head(); // clear the log
80102c69:	e8 12 ff ff ff       	call   80102b80 <write_head>
}
80102c6e:	83 c4 10             	add    $0x10,%esp
80102c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c74:	c9                   	leave  
80102c75:	c3                   	ret    
80102c76:	8d 76 00             	lea    0x0(%esi),%esi
80102c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c86:	68 a0 36 11 80       	push   $0x801136a0
80102c8b:	e8 70 1b 00 00       	call   80104800 <acquire>
80102c90:	83 c4 10             	add    $0x10,%esp
80102c93:	eb 18                	jmp    80102cad <begin_op+0x2d>
80102c95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c98:	83 ec 08             	sub    $0x8,%esp
80102c9b:	68 a0 36 11 80       	push   $0x801136a0
80102ca0:	68 a0 36 11 80       	push   $0x801136a0
80102ca5:	e8 56 10 00 00       	call   80103d00 <sleep>
80102caa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102cad:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102cb2:	85 c0                	test   %eax,%eax
80102cb4:	75 e2                	jne    80102c98 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102cb6:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102cbb:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102cc1:	83 c0 01             	add    $0x1,%eax
80102cc4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102cc7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102cca:	83 fa 1e             	cmp    $0x1e,%edx
80102ccd:	7f c9                	jg     80102c98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ccf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102cd2:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102cd7:	68 a0 36 11 80       	push   $0x801136a0
80102cdc:	e8 df 1b 00 00       	call   801048c0 <release>
      break;
    }
  }
}
80102ce1:	83 c4 10             	add    $0x10,%esp
80102ce4:	c9                   	leave  
80102ce5:	c3                   	ret    
80102ce6:	8d 76 00             	lea    0x0(%esi),%esi
80102ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cf0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	57                   	push   %edi
80102cf4:	56                   	push   %esi
80102cf5:	53                   	push   %ebx
80102cf6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102cf9:	68 a0 36 11 80       	push   $0x801136a0
80102cfe:	e8 fd 1a 00 00       	call   80104800 <acquire>
  log.outstanding -= 1;
80102d03:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102d08:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102d0e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d11:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102d14:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102d16:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102d1c:	0f 85 1a 01 00 00    	jne    80102e3c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102d22:	85 db                	test   %ebx,%ebx
80102d24:	0f 85 ee 00 00 00    	jne    80102e18 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d2a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102d2d:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102d34:	00 00 00 
  release(&log.lock);
80102d37:	68 a0 36 11 80       	push   $0x801136a0
80102d3c:	e8 7f 1b 00 00       	call   801048c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d41:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102d47:	83 c4 10             	add    $0x10,%esp
80102d4a:	85 c9                	test   %ecx,%ecx
80102d4c:	0f 8e 85 00 00 00    	jle    80102dd7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d52:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102d57:	83 ec 08             	sub    $0x8,%esp
80102d5a:	01 d8                	add    %ebx,%eax
80102d5c:	83 c0 01             	add    $0x1,%eax
80102d5f:	50                   	push   %eax
80102d60:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102d66:	e8 65 d3 ff ff       	call   801000d0 <bread>
80102d6b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d6d:	58                   	pop    %eax
80102d6e:	5a                   	pop    %edx
80102d6f:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102d76:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d7c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d7f:	e8 4c d3 ff ff       	call   801000d0 <bread>
80102d84:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d86:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d89:	83 c4 0c             	add    $0xc,%esp
80102d8c:	68 00 02 00 00       	push   $0x200
80102d91:	50                   	push   %eax
80102d92:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d95:	50                   	push   %eax
80102d96:	e8 25 1c 00 00       	call   801049c0 <memmove>
    bwrite(to);  // write the log
80102d9b:	89 34 24             	mov    %esi,(%esp)
80102d9e:	e8 fd d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102da3:	89 3c 24             	mov    %edi,(%esp)
80102da6:	e8 35 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102dab:	89 34 24             	mov    %esi,(%esp)
80102dae:	e8 2d d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102db3:	83 c4 10             	add    $0x10,%esp
80102db6:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102dbc:	7c 94                	jl     80102d52 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102dbe:	e8 bd fd ff ff       	call   80102b80 <write_head>
    install_trans(); // Now install writes to home locations
80102dc3:	e8 18 fd ff ff       	call   80102ae0 <install_trans>
    log.lh.n = 0;
80102dc8:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102dcf:	00 00 00 
    write_head();    // Erase the transaction from the log
80102dd2:	e8 a9 fd ff ff       	call   80102b80 <write_head>
    acquire(&log.lock);
80102dd7:	83 ec 0c             	sub    $0xc,%esp
80102dda:	68 a0 36 11 80       	push   $0x801136a0
80102ddf:	e8 1c 1a 00 00       	call   80104800 <acquire>
    wakeup(&log);
80102de4:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102deb:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102df2:	00 00 00 
    wakeup(&log);
80102df5:	e8 66 13 00 00       	call   80104160 <wakeup>
    release(&log.lock);
80102dfa:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e01:	e8 ba 1a 00 00       	call   801048c0 <release>
80102e06:	83 c4 10             	add    $0x10,%esp
}
80102e09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e0c:	5b                   	pop    %ebx
80102e0d:	5e                   	pop    %esi
80102e0e:	5f                   	pop    %edi
80102e0f:	5d                   	pop    %ebp
80102e10:	c3                   	ret    
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102e18:	83 ec 0c             	sub    $0xc,%esp
80102e1b:	68 a0 36 11 80       	push   $0x801136a0
80102e20:	e8 3b 13 00 00       	call   80104160 <wakeup>
  release(&log.lock);
80102e25:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e2c:	e8 8f 1a 00 00       	call   801048c0 <release>
80102e31:	83 c4 10             	add    $0x10,%esp
}
80102e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5f                   	pop    %edi
80102e3a:	5d                   	pop    %ebp
80102e3b:	c3                   	ret    
    panic("log.committing");
80102e3c:	83 ec 0c             	sub    $0xc,%esp
80102e3f:	68 e4 88 10 80       	push   $0x801088e4
80102e44:	e8 37 d5 ff ff       	call   80100380 <panic>
80102e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e57:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102e5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e60:	83 fa 1d             	cmp    $0x1d,%edx
80102e63:	0f 8f 9d 00 00 00    	jg     80102f06 <log_write+0xb6>
80102e69:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102e6e:	83 e8 01             	sub    $0x1,%eax
80102e71:	39 c2                	cmp    %eax,%edx
80102e73:	0f 8d 8d 00 00 00    	jge    80102f06 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e79:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102e7e:	85 c0                	test   %eax,%eax
80102e80:	0f 8e 8d 00 00 00    	jle    80102f13 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e86:	83 ec 0c             	sub    $0xc,%esp
80102e89:	68 a0 36 11 80       	push   $0x801136a0
80102e8e:	e8 6d 19 00 00       	call   80104800 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e93:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e99:	83 c4 10             	add    $0x10,%esp
80102e9c:	83 f9 00             	cmp    $0x0,%ecx
80102e9f:	7e 57                	jle    80102ef8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ea1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102ea4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ea6:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
80102eac:	75 0b                	jne    80102eb9 <log_write+0x69>
80102eae:	eb 38                	jmp    80102ee8 <log_write+0x98>
80102eb0:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80102eb7:	74 2f                	je     80102ee8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102eb9:	83 c0 01             	add    $0x1,%eax
80102ebc:	39 c1                	cmp    %eax,%ecx
80102ebe:	75 f0                	jne    80102eb0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ec0:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102ec7:	83 c0 01             	add    $0x1,%eax
80102eca:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102ecf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102ed2:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102ed9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102edc:	c9                   	leave  
  release(&log.lock);
80102edd:	e9 de 19 00 00       	jmp    801048c0 <release>
80102ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102ee8:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
80102eef:	eb de                	jmp    80102ecf <log_write+0x7f>
80102ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ef8:	8b 43 08             	mov    0x8(%ebx),%eax
80102efb:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102f00:	75 cd                	jne    80102ecf <log_write+0x7f>
80102f02:	31 c0                	xor    %eax,%eax
80102f04:	eb c1                	jmp    80102ec7 <log_write+0x77>
    panic("too big a transaction");
80102f06:	83 ec 0c             	sub    $0xc,%esp
80102f09:	68 f3 88 10 80       	push   $0x801088f3
80102f0e:	e8 6d d4 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102f13:	83 ec 0c             	sub    $0xc,%esp
80102f16:	68 09 89 10 80       	push   $0x80108909
80102f1b:	e8 60 d4 ff ff       	call   80100380 <panic>

80102f20 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f27:	e8 44 09 00 00       	call   80103870 <cpuid>
80102f2c:	89 c3                	mov    %eax,%ebx
80102f2e:	e8 3d 09 00 00       	call   80103870 <cpuid>
80102f33:	83 ec 04             	sub    $0x4,%esp
80102f36:	53                   	push   %ebx
80102f37:	50                   	push   %eax
80102f38:	68 24 89 10 80       	push   $0x80108924
80102f3d:	e8 0e d7 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102f42:	e8 f9 2f 00 00       	call   80105f40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f47:	e8 a4 08 00 00       	call   801037f0 <mycpu>
80102f4c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f4e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f53:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f5a:	e8 91 4b 00 00       	call   80107af0 <scheduler>
80102f5f:	90                   	nop

80102f60 <mpenter>:
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f66:	e8 35 41 00 00       	call   801070a0 <switchkvm>
  seginit();
80102f6b:	e8 a0 40 00 00       	call   80107010 <seginit>
  lapicinit();
80102f70:	e8 9b f7 ff ff       	call   80102710 <lapicinit>
  mpmain();
80102f75:	e8 a6 ff ff ff       	call   80102f20 <mpmain>
80102f7a:	66 90                	xchg   %ax,%ax
80102f7c:	66 90                	xchg   %ax,%ax
80102f7e:	66 90                	xchg   %ax,%ax

80102f80 <main>:
{
80102f80:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f84:	83 e4 f0             	and    $0xfffffff0,%esp
80102f87:	ff 71 fc             	pushl  -0x4(%ecx)
80102f8a:	55                   	push   %ebp
80102f8b:	89 e5                	mov    %esp,%ebp
80102f8d:	53                   	push   %ebx
80102f8e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f8f:	83 ec 08             	sub    $0x8,%esp
80102f92:	68 00 00 40 80       	push   $0x80400000
80102f97:	68 e8 88 11 80       	push   $0x801188e8
80102f9c:	e8 2f f5 ff ff       	call   801024d0 <kinit1>
  kvmalloc();      // kernel page table
80102fa1:	e8 da 45 00 00       	call   80107580 <kvmalloc>
  mpinit();        // detect other processors
80102fa6:	e8 75 01 00 00       	call   80103120 <mpinit>
  lapicinit();     // interrupt controller
80102fab:	e8 60 f7 ff ff       	call   80102710 <lapicinit>
  seginit();       // segment descriptors
80102fb0:	e8 5b 40 00 00       	call   80107010 <seginit>
  picinit();       // disable pic
80102fb5:	e8 46 03 00 00       	call   80103300 <picinit>
  ioapicinit();    // another interrupt controller
80102fba:	e8 41 f3 ff ff       	call   80102300 <ioapicinit>
  consoleinit();   // console hardware
80102fbf:	e8 ec d9 ff ff       	call   801009b0 <consoleinit>
  uartinit();      // serial port
80102fc4:	e8 17 33 00 00       	call   801062e0 <uartinit>
  pinit();         // process table
80102fc9:	e8 02 08 00 00       	call   801037d0 <pinit>
  tvinit();        // trap vectors
80102fce:	e8 ed 2e 00 00       	call   80105ec0 <tvinit>
  binit();         // buffer cache
80102fd3:	e8 68 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102fd8:	e8 63 de ff ff       	call   80100e40 <fileinit>
  ideinit();       // disk 
80102fdd:	e8 fe f0 ff ff       	call   801020e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102fe2:	83 c4 0c             	add    $0xc,%esp
80102fe5:	68 8a 00 00 00       	push   $0x8a
80102fea:	68 b4 b4 10 80       	push   $0x8010b4b4
80102fef:	68 00 70 00 80       	push   $0x80007000
80102ff4:	e8 c7 19 00 00       	call   801049c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ff9:	69 05 40 3d 11 80 b4 	imul   $0xb4,0x80113d40,%eax
80103000:	00 00 00 
80103003:	83 c4 10             	add    $0x10,%esp
80103006:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010300b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80103010:	76 71                	jbe    80103083 <main+0x103>
80103012:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80103017:	89 f6                	mov    %esi,%esi
80103019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103020:	e8 cb 07 00 00       	call   801037f0 <mycpu>
80103025:	39 d8                	cmp    %ebx,%eax
80103027:	74 41                	je     8010306a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103029:	e8 72 f5 ff ff       	call   801025a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010302e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103033:	c7 05 f8 6f 00 80 60 	movl   $0x80102f60,0x80006ff8
8010303a:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010303d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103044:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103047:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010304c:	0f b6 03             	movzbl (%ebx),%eax
8010304f:	83 ec 08             	sub    $0x8,%esp
80103052:	68 00 70 00 00       	push   $0x7000
80103057:	50                   	push   %eax
80103058:	e8 03 f8 ff ff       	call   80102860 <lapicstartap>
8010305d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103060:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103066:	85 c0                	test   %eax,%eax
80103068:	74 f6                	je     80103060 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010306a:	69 05 40 3d 11 80 b4 	imul   $0xb4,0x80113d40,%eax
80103071:	00 00 00 
80103074:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
8010307a:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010307f:	39 c3                	cmp    %eax,%ebx
80103081:	72 9d                	jb     80103020 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103083:	83 ec 08             	sub    $0x8,%esp
80103086:	68 00 00 00 8e       	push   $0x8e000000
8010308b:	68 00 00 40 80       	push   $0x80400000
80103090:	e8 ab f4 ff ff       	call   80102540 <kinit2>
  userinit();      // first user process
80103095:	e8 86 08 00 00       	call   80103920 <userinit>
  mpmain();        // finish this processor's setup
8010309a:	e8 81 fe ff ff       	call   80102f20 <mpmain>
8010309f:	90                   	nop

801030a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	57                   	push   %edi
801030a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801030ab:	53                   	push   %ebx
  e = addr+len;
801030ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801030b2:	39 de                	cmp    %ebx,%esi
801030b4:	72 10                	jb     801030c6 <mpsearch1+0x26>
801030b6:	eb 50                	jmp    80103108 <mpsearch1+0x68>
801030b8:	90                   	nop
801030b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030c0:	39 fb                	cmp    %edi,%ebx
801030c2:	89 fe                	mov    %edi,%esi
801030c4:	76 42                	jbe    80103108 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030c6:	83 ec 04             	sub    $0x4,%esp
801030c9:	8d 7e 10             	lea    0x10(%esi),%edi
801030cc:	6a 04                	push   $0x4
801030ce:	68 38 89 10 80       	push   $0x80108938
801030d3:	56                   	push   %esi
801030d4:	e8 87 18 00 00       	call   80104960 <memcmp>
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	85 c0                	test   %eax,%eax
801030de:	75 e0                	jne    801030c0 <mpsearch1+0x20>
801030e0:	89 f1                	mov    %esi,%ecx
801030e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801030e8:	0f b6 11             	movzbl (%ecx),%edx
801030eb:	83 c1 01             	add    $0x1,%ecx
801030ee:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801030f0:	39 f9                	cmp    %edi,%ecx
801030f2:	75 f4                	jne    801030e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030f4:	84 c0                	test   %al,%al
801030f6:	75 c8                	jne    801030c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801030f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030fb:	89 f0                	mov    %esi,%eax
801030fd:	5b                   	pop    %ebx
801030fe:	5e                   	pop    %esi
801030ff:	5f                   	pop    %edi
80103100:	5d                   	pop    %ebp
80103101:	c3                   	ret    
80103102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010310b:	31 f6                	xor    %esi,%esi
}
8010310d:	89 f0                	mov    %esi,%eax
8010310f:	5b                   	pop    %ebx
80103110:	5e                   	pop    %esi
80103111:	5f                   	pop    %edi
80103112:	5d                   	pop    %ebp
80103113:	c3                   	ret    
80103114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010311a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103120 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
80103125:	53                   	push   %ebx
80103126:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103129:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103130:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103137:	c1 e0 08             	shl    $0x8,%eax
8010313a:	09 d0                	or     %edx,%eax
8010313c:	c1 e0 04             	shl    $0x4,%eax
8010313f:	85 c0                	test   %eax,%eax
80103141:	75 1b                	jne    8010315e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103143:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010314a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103151:	c1 e0 08             	shl    $0x8,%eax
80103154:	09 d0                	or     %edx,%eax
80103156:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103159:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010315e:	ba 00 04 00 00       	mov    $0x400,%edx
80103163:	e8 38 ff ff ff       	call   801030a0 <mpsearch1>
80103168:	85 c0                	test   %eax,%eax
8010316a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010316d:	0f 84 3d 01 00 00    	je     801032b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103176:	8b 58 04             	mov    0x4(%eax),%ebx
80103179:	85 db                	test   %ebx,%ebx
8010317b:	0f 84 4f 01 00 00    	je     801032d0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103181:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103187:	83 ec 04             	sub    $0x4,%esp
8010318a:	6a 04                	push   $0x4
8010318c:	68 55 89 10 80       	push   $0x80108955
80103191:	56                   	push   %esi
80103192:	e8 c9 17 00 00       	call   80104960 <memcmp>
80103197:	83 c4 10             	add    $0x10,%esp
8010319a:	85 c0                	test   %eax,%eax
8010319c:	0f 85 2e 01 00 00    	jne    801032d0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801031a2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031a9:	3c 01                	cmp    $0x1,%al
801031ab:	0f 95 c2             	setne  %dl
801031ae:	3c 04                	cmp    $0x4,%al
801031b0:	0f 95 c0             	setne  %al
801031b3:	20 c2                	and    %al,%dl
801031b5:	0f 85 15 01 00 00    	jne    801032d0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801031bb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801031c2:	66 85 ff             	test   %di,%di
801031c5:	74 1a                	je     801031e1 <mpinit+0xc1>
801031c7:	89 f0                	mov    %esi,%eax
801031c9:	01 f7                	add    %esi,%edi
  sum = 0;
801031cb:	31 d2                	xor    %edx,%edx
801031cd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801031d0:	0f b6 08             	movzbl (%eax),%ecx
801031d3:	83 c0 01             	add    $0x1,%eax
801031d6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801031d8:	39 c7                	cmp    %eax,%edi
801031da:	75 f4                	jne    801031d0 <mpinit+0xb0>
801031dc:	84 d2                	test   %dl,%dl
801031de:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801031e1:	85 f6                	test   %esi,%esi
801031e3:	0f 84 e7 00 00 00    	je     801032d0 <mpinit+0x1b0>
801031e9:	84 d2                	test   %dl,%dl
801031eb:	0f 85 df 00 00 00    	jne    801032d0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801031f1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801031f7:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031fc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103203:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103209:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010320e:	01 d6                	add    %edx,%esi
80103210:	39 c6                	cmp    %eax,%esi
80103212:	76 23                	jbe    80103237 <mpinit+0x117>
    switch(*p){
80103214:	0f b6 10             	movzbl (%eax),%edx
80103217:	80 fa 04             	cmp    $0x4,%dl
8010321a:	0f 87 ca 00 00 00    	ja     801032ea <mpinit+0x1ca>
80103220:	ff 24 95 7c 89 10 80 	jmp    *-0x7fef7684(,%edx,4)
80103227:	89 f6                	mov    %esi,%esi
80103229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103230:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103233:	39 c6                	cmp    %eax,%esi
80103235:	77 dd                	ja     80103214 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103237:	85 db                	test   %ebx,%ebx
80103239:	0f 84 9e 00 00 00    	je     801032dd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010323f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103242:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103246:	74 15                	je     8010325d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103248:	b8 70 00 00 00       	mov    $0x70,%eax
8010324d:	ba 22 00 00 00       	mov    $0x22,%edx
80103252:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103253:	ba 23 00 00 00       	mov    $0x23,%edx
80103258:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103259:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010325c:	ee                   	out    %al,(%dx)
  }
}
8010325d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103260:	5b                   	pop    %ebx
80103261:	5e                   	pop    %esi
80103262:	5f                   	pop    %edi
80103263:	5d                   	pop    %ebp
80103264:	c3                   	ret    
80103265:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103268:	8b 0d 40 3d 11 80    	mov    0x80113d40,%ecx
8010326e:	83 f9 07             	cmp    $0x7,%ecx
80103271:	7f 19                	jg     8010328c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103273:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103277:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
8010327d:	83 c1 01             	add    $0x1,%ecx
80103280:	89 0d 40 3d 11 80    	mov    %ecx,0x80113d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103286:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
8010328c:	83 c0 14             	add    $0x14,%eax
      continue;
8010328f:	e9 7c ff ff ff       	jmp    80103210 <mpinit+0xf0>
80103294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103298:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010329c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010329f:	88 15 80 37 11 80    	mov    %dl,0x80113780
      continue;
801032a5:	e9 66 ff ff ff       	jmp    80103210 <mpinit+0xf0>
801032aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801032b0:	ba 00 00 01 00       	mov    $0x10000,%edx
801032b5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032ba:	e8 e1 fd ff ff       	call   801030a0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032bf:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801032c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c4:	0f 85 a9 fe ff ff    	jne    80103173 <mpinit+0x53>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801032d0:	83 ec 0c             	sub    $0xc,%esp
801032d3:	68 3d 89 10 80       	push   $0x8010893d
801032d8:	e8 a3 d0 ff ff       	call   80100380 <panic>
    panic("Didn't find a suitable machine");
801032dd:	83 ec 0c             	sub    $0xc,%esp
801032e0:	68 5c 89 10 80       	push   $0x8010895c
801032e5:	e8 96 d0 ff ff       	call   80100380 <panic>
      ismp = 0;
801032ea:	31 db                	xor    %ebx,%ebx
801032ec:	e9 26 ff ff ff       	jmp    80103217 <mpinit+0xf7>
801032f1:	66 90                	xchg   %ax,%ax
801032f3:	66 90                	xchg   %ax,%ax
801032f5:	66 90                	xchg   %ax,%ax
801032f7:	66 90                	xchg   %ax,%ax
801032f9:	66 90                	xchg   %ax,%ax
801032fb:	66 90                	xchg   %ax,%ax
801032fd:	66 90                	xchg   %ax,%ax
801032ff:	90                   	nop

80103300 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103300:	55                   	push   %ebp
80103301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103306:	ba 21 00 00 00       	mov    $0x21,%edx
8010330b:	89 e5                	mov    %esp,%ebp
8010330d:	ee                   	out    %al,(%dx)
8010330e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103313:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103314:	5d                   	pop    %ebp
80103315:	c3                   	ret    
80103316:	66 90                	xchg   %ax,%ax
80103318:	66 90                	xchg   %ax,%ax
8010331a:	66 90                	xchg   %ax,%ax
8010331c:	66 90                	xchg   %ax,%ax
8010331e:	66 90                	xchg   %ax,%ax

80103320 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 0c             	sub    $0xc,%esp
80103329:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010332c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010332f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103335:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010333b:	e8 20 db ff ff       	call   80100e60 <filealloc>
80103340:	85 c0                	test   %eax,%eax
80103342:	89 03                	mov    %eax,(%ebx)
80103344:	74 22                	je     80103368 <pipealloc+0x48>
80103346:	e8 15 db ff ff       	call   80100e60 <filealloc>
8010334b:	85 c0                	test   %eax,%eax
8010334d:	89 06                	mov    %eax,(%esi)
8010334f:	74 3f                	je     80103390 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103351:	e8 4a f2 ff ff       	call   801025a0 <kalloc>
80103356:	85 c0                	test   %eax,%eax
80103358:	89 c7                	mov    %eax,%edi
8010335a:	75 54                	jne    801033b0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010335c:	8b 03                	mov    (%ebx),%eax
8010335e:	85 c0                	test   %eax,%eax
80103360:	75 34                	jne    80103396 <pipealloc+0x76>
80103362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103368:	8b 06                	mov    (%esi),%eax
8010336a:	85 c0                	test   %eax,%eax
8010336c:	74 0c                	je     8010337a <pipealloc+0x5a>
    fileclose(*f1);
8010336e:	83 ec 0c             	sub    $0xc,%esp
80103371:	50                   	push   %eax
80103372:	e8 a9 db ff ff       	call   80100f20 <fileclose>
80103377:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010337a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010337d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103382:	5b                   	pop    %ebx
80103383:	5e                   	pop    %esi
80103384:	5f                   	pop    %edi
80103385:	5d                   	pop    %ebp
80103386:	c3                   	ret    
80103387:	89 f6                	mov    %esi,%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103390:	8b 03                	mov    (%ebx),%eax
80103392:	85 c0                	test   %eax,%eax
80103394:	74 e4                	je     8010337a <pipealloc+0x5a>
    fileclose(*f0);
80103396:	83 ec 0c             	sub    $0xc,%esp
80103399:	50                   	push   %eax
8010339a:	e8 81 db ff ff       	call   80100f20 <fileclose>
  if(*f1)
8010339f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801033a1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801033a4:	85 c0                	test   %eax,%eax
801033a6:	75 c6                	jne    8010336e <pipealloc+0x4e>
801033a8:	eb d0                	jmp    8010337a <pipealloc+0x5a>
801033aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801033b0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801033b3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033ba:	00 00 00 
  p->writeopen = 1;
801033bd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033c4:	00 00 00 
  p->nwrite = 0;
801033c7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033ce:	00 00 00 
  p->nread = 0;
801033d1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033d8:	00 00 00 
  initlock(&p->lock, "pipe");
801033db:	68 90 89 10 80       	push   $0x80108990
801033e0:	50                   	push   %eax
801033e1:	e8 da 12 00 00       	call   801046c0 <initlock>
  (*f0)->type = FD_PIPE;
801033e6:	8b 03                	mov    (%ebx),%eax
  return 0;
801033e8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801033eb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033f1:	8b 03                	mov    (%ebx),%eax
801033f3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033f7:	8b 03                	mov    (%ebx),%eax
801033f9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033fd:	8b 03                	mov    (%ebx),%eax
801033ff:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103402:	8b 06                	mov    (%esi),%eax
80103404:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010340a:	8b 06                	mov    (%esi),%eax
8010340c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103410:	8b 06                	mov    (%esi),%eax
80103412:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103416:	8b 06                	mov    (%esi),%eax
80103418:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010341b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010341e:	31 c0                	xor    %eax,%eax
}
80103420:	5b                   	pop    %ebx
80103421:	5e                   	pop    %esi
80103422:	5f                   	pop    %edi
80103423:	5d                   	pop    %ebp
80103424:	c3                   	ret    
80103425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103430 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	56                   	push   %esi
80103434:	53                   	push   %ebx
80103435:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103438:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010343b:	83 ec 0c             	sub    $0xc,%esp
8010343e:	53                   	push   %ebx
8010343f:	e8 bc 13 00 00       	call   80104800 <acquire>
  if(writable){
80103444:	83 c4 10             	add    $0x10,%esp
80103447:	85 f6                	test   %esi,%esi
80103449:	74 45                	je     80103490 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010344b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103451:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103454:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010345b:	00 00 00 
    wakeup(&p->nread);
8010345e:	50                   	push   %eax
8010345f:	e8 fc 0c 00 00       	call   80104160 <wakeup>
80103464:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103467:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010346d:	85 d2                	test   %edx,%edx
8010346f:	75 0a                	jne    8010347b <pipeclose+0x4b>
80103471:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103477:	85 c0                	test   %eax,%eax
80103479:	74 35                	je     801034b0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010347b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010347e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103481:	5b                   	pop    %ebx
80103482:	5e                   	pop    %esi
80103483:	5d                   	pop    %ebp
    release(&p->lock);
80103484:	e9 37 14 00 00       	jmp    801048c0 <release>
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103490:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103496:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103499:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034a0:	00 00 00 
    wakeup(&p->nwrite);
801034a3:	50                   	push   %eax
801034a4:	e8 b7 0c 00 00       	call   80104160 <wakeup>
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	eb b9                	jmp    80103467 <pipeclose+0x37>
801034ae:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801034b0:	83 ec 0c             	sub    $0xc,%esp
801034b3:	53                   	push   %ebx
801034b4:	e8 07 14 00 00       	call   801048c0 <release>
    kfree((char*)p);
801034b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034bc:	83 c4 10             	add    $0x10,%esp
}
801034bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034c2:	5b                   	pop    %ebx
801034c3:	5e                   	pop    %esi
801034c4:	5d                   	pop    %ebp
    kfree((char*)p);
801034c5:	e9 26 ef ff ff       	jmp    801023f0 <kfree>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801034d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	57                   	push   %edi
801034d4:	56                   	push   %esi
801034d5:	53                   	push   %ebx
801034d6:	83 ec 28             	sub    $0x28,%esp
801034d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801034dc:	53                   	push   %ebx
801034dd:	e8 1e 13 00 00       	call   80104800 <acquire>
  for(i = 0; i < n; i++){
801034e2:	8b 45 10             	mov    0x10(%ebp),%eax
801034e5:	83 c4 10             	add    $0x10,%esp
801034e8:	85 c0                	test   %eax,%eax
801034ea:	0f 8e d9 00 00 00    	jle    801035c9 <pipewrite+0xf9>
801034f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801034f3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
 //     if(p->readopen == 0 || myproc()->killed){
     if(p->readopen == 0 || myproc()->killed || myproc()->exited){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801034ff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103502:	03 4d 10             	add    0x10(%ebp),%ecx
80103505:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103508:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010350e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103514:	39 d0                	cmp    %edx,%eax
80103516:	75 7d                	jne    80103595 <pipewrite+0xc5>
     if(p->readopen == 0 || myproc()->killed || myproc()->exited){
80103518:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010351e:	85 c0                	test   %eax,%eax
80103520:	74 5a                	je     8010357c <pipewrite+0xac>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103522:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103528:	eb 46                	jmp    80103570 <pipewrite+0xa0>
8010352a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     if(p->readopen == 0 || myproc()->killed || myproc()->exited){
80103530:	e8 5b 03 00 00       	call   80103890 <myproc>
80103535:	8b 40 18             	mov    0x18(%eax),%eax
80103538:	85 c0                	test   %eax,%eax
8010353a:	75 40                	jne    8010357c <pipewrite+0xac>
      wakeup(&p->nread);
8010353c:	83 ec 0c             	sub    $0xc,%esp
8010353f:	57                   	push   %edi
80103540:	e8 1b 0c 00 00       	call   80104160 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103545:	5a                   	pop    %edx
80103546:	59                   	pop    %ecx
80103547:	53                   	push   %ebx
80103548:	56                   	push   %esi
80103549:	e8 b2 07 00 00       	call   80103d00 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010354e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103554:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	05 00 02 00 00       	add    $0x200,%eax
80103562:	39 c2                	cmp    %eax,%edx
80103564:	75 3a                	jne    801035a0 <pipewrite+0xd0>
     if(p->readopen == 0 || myproc()->killed || myproc()->exited){
80103566:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010356c:	85 c0                	test   %eax,%eax
8010356e:	74 0c                	je     8010357c <pipewrite+0xac>
80103570:	e8 1b 03 00 00       	call   80103890 <myproc>
80103575:	8b 40 14             	mov    0x14(%eax),%eax
80103578:	85 c0                	test   %eax,%eax
8010357a:	74 b4                	je     80103530 <pipewrite+0x60>
        release(&p->lock);
8010357c:	83 ec 0c             	sub    $0xc,%esp
8010357f:	53                   	push   %ebx
80103580:	e8 3b 13 00 00       	call   801048c0 <release>
        return -1;
80103585:	83 c4 10             	add    $0x10,%esp
80103588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010358d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103590:	5b                   	pop    %ebx
80103591:	5e                   	pop    %esi
80103592:	5f                   	pop    %edi
80103593:	5d                   	pop    %ebp
80103594:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103595:	89 c2                	mov    %eax,%edx
80103597:	89 f6                	mov    %esi,%esi
80103599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035a0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801035a3:	8d 42 01             	lea    0x1(%edx),%eax
801035a6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035ac:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801035b2:	83 c6 01             	add    $0x1,%esi
801035b5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801035b9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801035bc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035bf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801035c3:	0f 85 3f ff ff ff    	jne    80103508 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035c9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035cf:	83 ec 0c             	sub    $0xc,%esp
801035d2:	50                   	push   %eax
801035d3:	e8 88 0b 00 00       	call   80104160 <wakeup>
  release(&p->lock);
801035d8:	89 1c 24             	mov    %ebx,(%esp)
801035db:	e8 e0 12 00 00       	call   801048c0 <release>
  return n;
801035e0:	83 c4 10             	add    $0x10,%esp
801035e3:	8b 45 10             	mov    0x10(%ebp),%eax
801035e6:	eb a5                	jmp    8010358d <pipewrite+0xbd>
801035e8:	90                   	nop
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 18             	sub    $0x18,%esp
801035f9:	8b 75 08             	mov    0x8(%ebp),%esi
801035fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035ff:	56                   	push   %esi
80103600:	e8 fb 11 00 00       	call   80104800 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103605:	83 c4 10             	add    $0x10,%esp
80103608:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010360e:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103614:	75 7a                	jne    80103690 <piperead+0xa0>
80103616:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
8010361c:	85 c0                	test   %eax,%eax
8010361e:	0f 84 d4 00 00 00    	je     801036f8 <piperead+0x108>
//    if(myproc()->killed){
    if(myproc()->killed || myproc()->exited){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103624:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010362a:	eb 39                	jmp    80103665 <piperead+0x75>
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed || myproc()->exited){
80103630:	e8 5b 02 00 00       	call   80103890 <myproc>
80103635:	8b 40 18             	mov    0x18(%eax),%eax
80103638:	85 c0                	test   %eax,%eax
8010363a:	75 35                	jne    80103671 <piperead+0x81>
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010363c:	83 ec 08             	sub    $0x8,%esp
8010363f:	56                   	push   %esi
80103640:	53                   	push   %ebx
80103641:	e8 ba 06 00 00       	call   80103d00 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103646:	83 c4 10             	add    $0x10,%esp
80103649:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010364f:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103655:	75 39                	jne    80103690 <piperead+0xa0>
80103657:	8b 8e 40 02 00 00    	mov    0x240(%esi),%ecx
8010365d:	85 c9                	test   %ecx,%ecx
8010365f:	0f 84 93 00 00 00    	je     801036f8 <piperead+0x108>
    if(myproc()->killed || myproc()->exited){
80103665:	e8 26 02 00 00       	call   80103890 <myproc>
8010366a:	8b 40 14             	mov    0x14(%eax),%eax
8010366d:	85 c0                	test   %eax,%eax
8010366f:	74 bf                	je     80103630 <piperead+0x40>
      release(&p->lock);
80103671:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103674:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103679:	56                   	push   %esi
8010367a:	e8 41 12 00 00       	call   801048c0 <release>
      return -1;
8010367f:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103682:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103685:	89 d8                	mov    %ebx,%eax
80103687:	5b                   	pop    %ebx
80103688:	5e                   	pop    %esi
80103689:	5f                   	pop    %edi
8010368a:	5d                   	pop    %ebp
8010368b:	c3                   	ret    
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103690:	8b 55 10             	mov    0x10(%ebp),%edx
80103693:	85 d2                	test   %edx,%edx
80103695:	7e 61                	jle    801036f8 <piperead+0x108>
    if(p->nread == p->nwrite)
80103697:	89 c1                	mov    %eax,%ecx
80103699:	31 db                	xor    %ebx,%ebx
8010369b:	eb 11                	jmp    801036ae <piperead+0xbe>
8010369d:	8d 76 00             	lea    0x0(%esi),%esi
801036a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036ac:	74 1f                	je     801036cd <piperead+0xdd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036ae:	8d 41 01             	lea    0x1(%ecx),%eax
801036b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801036b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801036bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801036c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036c5:	83 c3 01             	add    $0x1,%ebx
801036c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801036cb:	75 d3                	jne    801036a0 <piperead+0xb0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	50                   	push   %eax
801036d7:	e8 84 0a 00 00       	call   80104160 <wakeup>
  release(&p->lock);
801036dc:	89 34 24             	mov    %esi,(%esp)
801036df:	e8 dc 11 00 00       	call   801048c0 <release>
  return i;
801036e4:	83 c4 10             	add    $0x10,%esp
}
801036e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ea:	89 d8                	mov    %ebx,%eax
801036ec:	5b                   	pop    %ebx
801036ed:	5e                   	pop    %esi
801036ee:	5f                   	pop    %edi
801036ef:	5d                   	pop    %ebp
801036f0:	c3                   	ret    
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036f8:	31 db                	xor    %ebx,%ebx
801036fa:	eb d1                	jmp    801036cd <piperead+0xdd>
801036fc:	66 90                	xchg   %ax,%ax
801036fe:	66 90                	xchg   %ax,%ax

80103700 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	53                   	push   %ebx
  struct proc *p;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103704:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
{
80103709:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010370c:	68 60 3d 11 80       	push   $0x80113d60
80103711:	e8 ea 10 00 00       	call   80104800 <acquire>
80103716:	83 c4 10             	add    $0x10,%esp
80103719:	eb 13                	jmp    8010372e <allocproc+0x2e>
8010371b:	90                   	nop
8010371c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103720:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103726:	81 fb 94 60 11 80    	cmp    $0x80116094,%ebx
8010372c:	73 3a                	jae    80103768 <allocproc+0x68>
    if(p->state == UNUSED)
8010372e:	8b 43 08             	mov    0x8(%ebx),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 eb                	jne    80103720 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103735:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010373a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010373d:	c7 43 08 02 00 00 00 	movl   $0x2,0x8(%ebx)
  p->pid = nextpid++;
80103744:	89 43 0c             	mov    %eax,0xc(%ebx)
80103747:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010374a:	68 60 3d 11 80       	push   $0x80113d60
  p->pid = nextpid++;
8010374f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103755:	e8 66 11 00 00       	call   801048c0 <release>

  return p;
}
8010375a:	89 d8                	mov    %ebx,%eax
  return p;
8010375c:	83 c4 10             	add    $0x10,%esp
}
8010375f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103762:	c9                   	leave  
80103763:	c3                   	ret    
80103764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103768:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010376b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010376d:	68 60 3d 11 80       	push   $0x80113d60
80103772:	e8 49 11 00 00       	call   801048c0 <release>
}
80103777:	89 d8                	mov    %ebx,%eax
  return 0;
80103779:	83 c4 10             	add    $0x10,%esp
}
8010377c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010377f:	c9                   	leave  
80103780:	c3                   	ret    
80103781:	eb 0d                	jmp    80103790 <setstate.part.0>
80103783:	90                   	nop
80103784:	90                   	nop
80103785:	90                   	nop
80103786:	90                   	nop
80103787:	90                   	nop
80103788:	90                   	nop
80103789:	90                   	nop
8010378a:	90                   	nop
8010378b:	90                   	nop
8010378c:	90                   	nop
8010378d:	90                   	nop
8010378e:	90                   	nop
8010378f:	90                   	nop

80103790 <setstate.part.0>:
setstate(struct proc *curproc, struct thread *curthd, int state)
80103790:	55                   	push   %ebp
  s = UNUSED;
80103791:	31 c9                	xor    %ecx,%ecx
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103793:	ba 94 60 11 80       	mov    $0x80116094,%edx
setstate(struct proc *curproc, struct thread *curthd, int state)
80103798:	89 e5                	mov    %esp,%ebp
8010379a:	56                   	push   %esi
8010379b:	53                   	push   %ebx
8010379c:	eb 0d                	jmp    801037ab <setstate.part.0+0x1b>
8010379e:	66 90                	xchg   %ax,%ax
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
801037a0:	83 c2 20             	add    $0x20,%edx
801037a3:	81 fa 94 80 11 80    	cmp    $0x80118094,%edx
801037a9:	73 1d                	jae    801037c8 <setstate.part.0+0x38>
    if(t->mp == curproc && t->state > s)
801037ab:	39 42 10             	cmp    %eax,0x10(%edx)
801037ae:	89 cb                	mov    %ecx,%ebx
801037b0:	75 ee                	jne    801037a0 <setstate.part.0+0x10>
801037b2:	8b 72 08             	mov    0x8(%edx),%esi
801037b5:	39 ce                	cmp    %ecx,%esi
801037b7:	76 e7                	jbe    801037a0 <setstate.part.0+0x10>
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
801037b9:	83 c2 20             	add    $0x20,%edx
      s = t->state;
801037bc:	89 f1                	mov    %esi,%ecx
801037be:	89 f3                	mov    %esi,%ebx
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
801037c0:	81 fa 94 80 11 80    	cmp    $0x80118094,%edx
801037c6:	72 e3                	jb     801037ab <setstate.part.0+0x1b>
  curproc->state = s;
801037c8:	89 58 08             	mov    %ebx,0x8(%eax)
}
801037cb:	5b                   	pop    %ebx
801037cc:	5e                   	pop    %esi
801037cd:	5d                   	pop    %ebp
801037ce:	c3                   	ret    
801037cf:	90                   	nop

801037d0 <pinit>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037d6:	68 95 89 10 80       	push   $0x80108995
801037db:	68 60 3d 11 80       	push   $0x80113d60
801037e0:	e8 db 0e 00 00       	call   801046c0 <initlock>
}
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	c9                   	leave  
801037e9:	c3                   	ret    
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037f0 <mycpu>:
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037f5:	9c                   	pushf  
801037f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037f7:	f6 c4 02             	test   $0x2,%ah
801037fa:	75 5e                	jne    8010385a <mycpu+0x6a>
  apicid = lapicid();
801037fc:	e8 0f f0 ff ff       	call   80102810 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103801:	8b 35 40 3d 11 80    	mov    0x80113d40,%esi
80103807:	85 f6                	test   %esi,%esi
80103809:	7e 42                	jle    8010384d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010380b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103812:	39 d0                	cmp    %edx,%eax
80103814:	74 30                	je     80103846 <mycpu+0x56>
80103816:	b9 54 38 11 80       	mov    $0x80113854,%ecx
  for (i = 0; i < ncpu; ++i) {
8010381b:	31 d2                	xor    %edx,%edx
8010381d:	8d 76 00             	lea    0x0(%esi),%esi
80103820:	83 c2 01             	add    $0x1,%edx
80103823:	39 f2                	cmp    %esi,%edx
80103825:	74 26                	je     8010384d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103827:	0f b6 19             	movzbl (%ecx),%ebx
8010382a:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
80103830:	39 c3                	cmp    %eax,%ebx
80103832:	75 ec                	jne    80103820 <mycpu+0x30>
80103834:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
8010383a:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
8010383f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103842:	5b                   	pop    %ebx
80103843:	5e                   	pop    %esi
80103844:	5d                   	pop    %ebp
80103845:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103846:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
      return &cpus[i];
8010384b:	eb f2                	jmp    8010383f <mycpu+0x4f>
  panic("unknown apicid\n");
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	68 9c 89 10 80       	push   $0x8010899c
80103855:	e8 26 cb ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
8010385a:	83 ec 0c             	sub    $0xc,%esp
8010385d:	68 44 8a 10 80       	push   $0x80108a44
80103862:	e8 19 cb ff ff       	call   80100380 <panic>
80103867:	89 f6                	mov    %esi,%esi
80103869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103870 <cpuid>:
cpuid() {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103876:	e8 75 ff ff ff       	call   801037f0 <mycpu>
8010387b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103880:	c9                   	leave  
  return mycpu()-cpus;
80103881:	c1 f8 02             	sar    $0x2,%eax
80103884:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
8010388a:	c3                   	ret    
8010388b:	90                   	nop
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103890 <myproc>:
myproc(void) {
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103897:	e8 94 0e 00 00       	call   80104730 <pushcli>
  c = mycpu();
8010389c:	e8 4f ff ff ff       	call   801037f0 <mycpu>
  p = c->proc;
801038a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038a7:	e8 c4 0e 00 00       	call   80104770 <popcli>
}
801038ac:	83 c4 04             	add    $0x4,%esp
801038af:	89 d8                	mov    %ebx,%eax
801038b1:	5b                   	pop    %ebx
801038b2:	5d                   	pop    %ebp
801038b3:	c3                   	ret    
801038b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038c0 <mythd>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
801038c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038c7:	e8 64 0e 00 00       	call   80104730 <pushcli>
  c = mycpu();
801038cc:	e8 1f ff ff ff       	call   801037f0 <mycpu>
  t = c->thd;
801038d1:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  popcli();
801038d7:	e8 94 0e 00 00       	call   80104770 <popcli>
}
801038dc:	83 c4 04             	add    $0x4,%esp
801038df:	89 d8                	mov    %ebx,%eax
801038e1:	5b                   	pop    %ebx
801038e2:	5d                   	pop    %ebp
801038e3:	c3                   	ret    
801038e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038f0 <setstate>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	8b 55 10             	mov    0x10(%ebp),%edx
801038f6:	8b 45 08             	mov    0x8(%ebp),%eax
  curthd->state = state;
801038f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801038fc:	89 51 08             	mov    %edx,0x8(%ecx)
  if(curproc->state <= state){
801038ff:	3b 50 08             	cmp    0x8(%eax),%edx
80103902:	73 0c                	jae    80103910 <setstate+0x20>
}
80103904:	5d                   	pop    %ebp
80103905:	e9 86 fe ff ff       	jmp    80103790 <setstate.part.0>
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    curproc->state = state;
80103910:	89 50 08             	mov    %edx,0x8(%eax)
}
80103913:	5d                   	pop    %ebp
80103914:	c3                   	ret    
80103915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103920 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
  struct proc *p;
  struct thread *t;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103925:	e8 d6 fd ff ff       	call   80103700 <allocproc>
8010392a:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010392c:	a3 d8 b5 10 80       	mov    %eax,0x8010b5d8
  if((p->pgdir = setupkvm()) == 0)
80103931:	e8 ca 3b 00 00       	call   80107500 <setupkvm>
80103936:	85 c0                	test   %eax,%eax
80103938:	89 43 04             	mov    %eax,0x4(%ebx)
8010393b:	0f 84 08 01 00 00    	je     80103a49 <userinit+0x129>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103941:	83 ec 04             	sub    $0x4,%esp
80103944:	68 2c 00 00 00       	push   $0x2c
80103949:	68 88 b4 10 80       	push   $0x8010b488
8010394e:	50                   	push   %eax
8010394f:	e8 8c 38 00 00       	call   801071e0 <inituvm>
  p->sz = PGSIZE;
80103954:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)

  t = allocthd(p);
8010395a:	89 1c 24             	mov    %ebx,(%esp)
8010395d:	e8 ae 45 00 00       	call   80107f10 <allocthd>
  p->pin = t;

  memset(t->tf, 0, sizeof(*t->tf));
80103962:	83 c4 0c             	add    $0xc,%esp
  p->pin = t;
80103965:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  t = allocthd(p);
8010396b:	89 c6                	mov    %eax,%esi
  memset(t->tf, 0, sizeof(*t->tf));
8010396d:	6a 4c                	push   $0x4c
8010396f:	6a 00                	push   $0x0
80103971:	ff 70 14             	pushl  0x14(%eax)
80103974:	e8 97 0f 00 00       	call   80104910 <memset>
  t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103979:	8b 46 14             	mov    0x14(%esi),%eax
8010397c:	ba 1b 00 00 00       	mov    $0x1b,%edx
  t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103981:	b9 23 00 00 00       	mov    $0x23,%ecx
  // set queue state.
  p->stype = MLFQ;
  p->qlev = HQLEV;
  p->pass = 0;

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103986:	83 c4 0c             	add    $0xc,%esp
  t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103989:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010398d:	8b 46 14             	mov    0x14(%esi),%eax
80103990:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  t->tf->es = t->tf->ds;
80103994:	8b 46 14             	mov    0x14(%esi),%eax
80103997:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010399b:	66 89 50 28          	mov    %dx,0x28(%eax)
  t->tf->ss = t->tf->ds;
8010399f:	8b 46 14             	mov    0x14(%esi),%eax
801039a2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039a6:	66 89 50 48          	mov    %dx,0x48(%eax)
  t->tf->eflags = FL_IF;
801039aa:	8b 46 14             	mov    0x14(%esi),%eax
801039ad:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  t->tf->esp = p->sz;
801039b4:	8b 46 14             	mov    0x14(%esi),%eax
801039b7:	8b 13                	mov    (%ebx),%edx
801039b9:	89 50 44             	mov    %edx,0x44(%eax)
  t->tf->eip = 0;  // beginning of initcode.S
801039bc:	8b 46 14             	mov    0x14(%esi),%eax
801039bf:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039c6:	8d 43 60             	lea    0x60(%ebx),%eax
  p->stype = MLFQ;
801039c9:	c7 43 70 01 00 00 00 	movl   $0x1,0x70(%ebx)
  p->qlev = HQLEV;
801039d0:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
  p->pass = 0;
801039d7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801039de:	00 00 00 
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039e1:	6a 10                	push   $0x10
801039e3:	68 c5 89 10 80       	push   $0x801089c5
801039e8:	50                   	push   %eax
801039e9:	e8 02 11 00 00       	call   80104af0 <safestrcpy>
  p->cwd = namei("/");
801039ee:	c7 04 24 ce 89 10 80 	movl   $0x801089ce,(%esp)
801039f5:	e8 c6 e5 ff ff       	call   80101fc0 <namei>
801039fa:	89 43 5c             	mov    %eax,0x5c(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801039fd:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103a04:	e8 f7 0d 00 00       	call   80104800 <acquire>
  curthd->state = state;
80103a09:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
  if(curproc->state <= state){
80103a10:	83 c4 10             	add    $0x10,%esp
80103a13:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
80103a17:	77 27                	ja     80103a40 <userinit+0x120>
    curproc->state = state;
80103a19:	c7 43 08 05 00 00 00 	movl   $0x5,0x8(%ebx)
  setstate(p, t, RUNNABLE);
  release(&ptable.lock);
80103a20:	83 ec 0c             	sub    $0xc,%esp
80103a23:	68 60 3d 11 80       	push   $0x80113d60
80103a28:	e8 93 0e 00 00       	call   801048c0 <release>
}
80103a2d:	83 c4 10             	add    $0x10,%esp
80103a30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a33:	5b                   	pop    %ebx
80103a34:	5e                   	pop    %esi
80103a35:	5d                   	pop    %ebp
80103a36:	c3                   	ret    
80103a37:	89 f6                	mov    %esi,%esi
80103a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103a40:	89 d8                	mov    %ebx,%eax
80103a42:	e8 49 fd ff ff       	call   80103790 <setstate.part.0>
80103a47:	eb d7                	jmp    80103a20 <userinit+0x100>
    panic("userinit: out of memory?");
80103a49:	83 ec 0c             	sub    $0xc,%esp
80103a4c:	68 ac 89 10 80       	push   $0x801089ac
80103a51:	e8 2a c9 ff ff       	call   80100380 <panic>
80103a56:	8d 76 00             	lea    0x0(%esi),%esi
80103a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a60 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	56                   	push   %esi
80103a64:	53                   	push   %ebx
80103a65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a68:	e8 c3 0c 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103a6d:	e8 7e fd ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103a72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a78:	e8 f3 0c 00 00       	call   80104770 <popcli>
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103a7d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a80:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a82:	7f 1c                	jg     80103aa0 <growproc+0x40>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103a84:	75 3a                	jne    80103ac0 <growproc+0x60>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103a86:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a89:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a8b:	53                   	push   %ebx
80103a8c:	e8 2f 36 00 00       	call   801070c0 <switchuvm>
  return 0;
80103a91:	83 c4 10             	add    $0x10,%esp
80103a94:	31 c0                	xor    %eax,%eax
}
80103a96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a99:	5b                   	pop    %ebx
80103a9a:	5e                   	pop    %esi
80103a9b:	5d                   	pop    %ebp
80103a9c:	c3                   	ret    
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aa0:	83 ec 04             	sub    $0x4,%esp
80103aa3:	01 c6                	add    %eax,%esi
80103aa5:	56                   	push   %esi
80103aa6:	50                   	push   %eax
80103aa7:	ff 73 04             	pushl  0x4(%ebx)
80103aaa:	e8 71 38 00 00       	call   80107320 <allocuvm>
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 d0                	jne    80103a86 <growproc+0x26>
      return -1;
80103ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103abb:	eb d9                	jmp    80103a96 <growproc+0x36>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ac0:	83 ec 04             	sub    $0x4,%esp
80103ac3:	01 c6                	add    %eax,%esi
80103ac5:	56                   	push   %esi
80103ac6:	50                   	push   %eax
80103ac7:	ff 73 04             	pushl  0x4(%ebx)
80103aca:	e8 81 39 00 00       	call   80107450 <deallocuvm>
80103acf:	83 c4 10             	add    $0x10,%esp
80103ad2:	85 c0                	test   %eax,%eax
80103ad4:	75 b0                	jne    80103a86 <growproc+0x26>
80103ad6:	eb de                	jmp    80103ab6 <growproc+0x56>
80103ad8:	90                   	nop
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ae0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ae9:	e8 42 0c 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103aee:	e8 fd fc ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103af3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af9:	e8 72 0c 00 00       	call   80104770 <popcli>
  pushcli();
80103afe:	e8 2d 0c 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103b03:	e8 e8 fc ff ff       	call   801037f0 <mycpu>
  t = c->thd;
80103b08:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103b0e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  popcli();
80103b11:	e8 5a 0c 00 00       	call   80104770 <popcli>
  struct proc *np;
  struct thread *nth, *t;
  struct list *l;

  // Allocate process.
  if((np = allocproc()) == 0){
80103b16:	e8 e5 fb ff ff       	call   80103700 <allocproc>
80103b1b:	85 c0                	test   %eax,%eax
80103b1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b20:	0f 84 77 01 00 00    	je     80103c9d <fork+0x1bd>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b26:	83 ec 08             	sub    $0x8,%esp
80103b29:	ff 33                	pushl  (%ebx)
80103b2b:	ff 73 04             	pushl  0x4(%ebx)
80103b2e:	89 c7                	mov    %eax,%edi
80103b30:	e8 9b 3a 00 00       	call   801075d0 <copyuvm>
80103b35:	83 c4 10             	add    $0x10,%esp
80103b38:	85 c0                	test   %eax,%eax
80103b3a:	89 47 04             	mov    %eax,0x4(%edi)
80103b3d:	0f 84 49 01 00 00    	je     80103c8c <fork+0x1ac>
    np->state = UNUSED;
    return -1;
  }

  if ((nth = allocthd(np)) == 0){
80103b43:	83 ec 0c             	sub    $0xc,%esp
80103b46:	ff 75 e4             	pushl  -0x1c(%ebp)
80103b49:	e8 c2 43 00 00       	call   80107f10 <allocthd>
80103b4e:	83 c4 10             	add    $0x10,%esp
80103b51:	85 c0                	test   %eax,%eax
80103b53:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103b56:	0f 84 30 01 00 00    	je     80103c8c <fork+0x1ac>
    np->state = UNUSED;
    return -1;
  }
  np->pin = nth;
80103b5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b5f:	8b 4d e0             	mov    -0x20(%ebp),%ecx

  nth->usp = curthd->usp;
80103b62:	8b 7d dc             	mov    -0x24(%ebp),%edi
  np->pin = nth;
80103b65:	89 8a 88 00 00 00    	mov    %ecx,0x88(%edx)
  nth->usp = curthd->usp;
80103b6b:	8b 07                	mov    (%edi),%eax
80103b6d:	89 01                	mov    %eax,(%ecx)
  *nth->tf = *curthd->tf;
80103b6f:	8b 77 14             	mov    0x14(%edi),%esi
80103b72:	8b 79 14             	mov    0x14(%ecx),%edi
80103b75:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b7a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->sz = curproc->sz;
  np->parent = curproc;
80103b7c:	89 d7                	mov    %edx,%edi
  np->sz = curproc->sz;
80103b7e:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
80103b80:	89 5a 10             	mov    %ebx,0x10(%edx)
  np->sz = curproc->sz;
80103b83:	89 02                	mov    %eax,(%edx)

  for(l = curproc->fslist; l != 0; l = l->next)
80103b85:	8b b3 84 00 00 00    	mov    0x84(%ebx),%esi
80103b8b:	85 f6                	test   %esi,%esi
80103b8d:	74 16                	je     80103ba5 <fork+0xc5>
80103b8f:	90                   	nop
    ufree(np, l->usp);
80103b90:	83 ec 08             	sub    $0x8,%esp
80103b93:	ff 36                	pushl  (%esi)
80103b95:	57                   	push   %edi
80103b96:	e8 95 3c 00 00       	call   80107830 <ufree>
  for(l = curproc->fslist; l != 0; l = l->next)
80103b9b:	8b 76 04             	mov    0x4(%esi),%esi
80103b9e:	83 c4 10             	add    $0x10,%esp
80103ba1:	85 f6                	test   %esi,%esi
80103ba3:	75 eb                	jne    80103b90 <fork+0xb0>
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103ba5:	be 94 60 11 80       	mov    $0x80116094,%esi
80103baa:	8b 7d dc             	mov    -0x24(%ebp),%edi
80103bad:	eb 0c                	jmp    80103bbb <fork+0xdb>
80103baf:	90                   	nop
80103bb0:	83 c6 20             	add    $0x20,%esi
80103bb3:	81 fe 94 80 11 80    	cmp    $0x80118094,%esi
80103bb9:	73 25                	jae    80103be0 <fork+0x100>
    if(t->mp == curproc && t != curthd)
80103bbb:	39 5e 10             	cmp    %ebx,0x10(%esi)
80103bbe:	75 f0                	jne    80103bb0 <fork+0xd0>
80103bc0:	39 f7                	cmp    %esi,%edi
80103bc2:	74 ec                	je     80103bb0 <fork+0xd0>
      ufree(np, t->usp);
80103bc4:	83 ec 08             	sub    $0x8,%esp
80103bc7:	ff 36                	pushl  (%esi)
80103bc9:	ff 75 e4             	pushl  -0x1c(%ebp)
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103bcc:	83 c6 20             	add    $0x20,%esi
      ufree(np, t->usp);
80103bcf:	e8 5c 3c 00 00       	call   80107830 <ufree>
80103bd4:	83 c4 10             	add    $0x10,%esp
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103bd7:	81 fe 94 80 11 80    	cmp    $0x80118094,%esi
80103bdd:	72 dc                	jb     80103bbb <fork+0xdb>
80103bdf:	90                   	nop

  // Operating_Systems_Projects01.
  // fork queue state.
  np->stype = MLFQ;
80103be0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  np->qlev = HQLEV;
  np->pass = 0;

  // Clear %eax so that fork returns 0 in the child.
  nth->tf->eax = 0;
80103be3:	8b 45 e0             	mov    -0x20(%ebp),%eax

  for(i = 0; i < NOFILE; i++)
80103be6:	31 f6                	xor    %esi,%esi
  np->stype = MLFQ;
80103be8:	c7 47 70 01 00 00 00 	movl   $0x1,0x70(%edi)
  np->qlev = HQLEV;
80103bef:	c7 47 74 00 00 00 00 	movl   $0x0,0x74(%edi)
  np->pass = 0;
80103bf6:	c7 87 80 00 00 00 00 	movl   $0x0,0x80(%edi)
80103bfd:	00 00 00 
  nth->tf->eax = 0;
80103c00:	8b 40 14             	mov    0x14(%eax),%eax
80103c03:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103c10:	8b 44 b3 1c          	mov    0x1c(%ebx,%esi,4),%eax
80103c14:	85 c0                	test   %eax,%eax
80103c16:	74 10                	je     80103c28 <fork+0x148>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c18:	83 ec 0c             	sub    $0xc,%esp
80103c1b:	50                   	push   %eax
80103c1c:	e8 af d2 ff ff       	call   80100ed0 <filedup>
80103c21:	83 c4 10             	add    $0x10,%esp
80103c24:	89 44 b7 1c          	mov    %eax,0x1c(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c28:	83 c6 01             	add    $0x1,%esi
80103c2b:	83 fe 10             	cmp    $0x10,%esi
80103c2e:	75 e0                	jne    80103c10 <fork+0x130>
  np->cwd = idup(curproc->cwd);
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	ff 73 5c             	pushl  0x5c(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c36:	83 c3 60             	add    $0x60,%ebx
  np->cwd = idup(curproc->cwd);
80103c39:	e8 f2 da ff ff       	call   80101730 <idup>
80103c3e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c41:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c44:	89 47 5c             	mov    %eax,0x5c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c47:	8d 47 60             	lea    0x60(%edi),%eax
80103c4a:	6a 10                	push   $0x10
80103c4c:	53                   	push   %ebx
80103c4d:	50                   	push   %eax
80103c4e:	e8 9d 0e 00 00       	call   80104af0 <safestrcpy>

  pid = np->pid;
80103c53:	8b 5f 0c             	mov    0xc(%edi),%ebx

  acquire(&ptable.lock);
80103c56:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103c5d:	e8 9e 0b 00 00       	call   80104800 <acquire>

  np->state = RUNNABLE;
  nth->state = RUNNABLE;
80103c62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  np->state = RUNNABLE;
80103c65:	c7 47 08 05 00 00 00 	movl   $0x5,0x8(%edi)
  nth->state = RUNNABLE;
80103c6c:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)

  release(&ptable.lock);
80103c73:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80103c7a:	e8 41 0c 00 00       	call   801048c0 <release>
  return pid;
80103c7f:	83 c4 10             	add    $0x10,%esp
}
80103c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c85:	89 d8                	mov    %ebx,%eax
80103c87:	5b                   	pop    %ebx
80103c88:	5e                   	pop    %esi
80103c89:	5f                   	pop    %edi
80103c8a:	5d                   	pop    %ebp
80103c8b:	c3                   	ret    
    np->state = UNUSED;
80103c8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    return -1;
80103c8f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    np->state = UNUSED;
80103c94:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return -1;
80103c9b:	eb e5                	jmp    80103c82 <fork+0x1a2>
    return -1;
80103c9d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ca2:	eb de                	jmp    80103c82 <fork+0x1a2>
80103ca4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103caa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103cb0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103cb6:	68 60 3d 11 80       	push   $0x80113d60
80103cbb:	e8 00 0c 00 00       	call   801048c0 <release>

  if (first) {
80103cc0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	85 c0                	test   %eax,%eax
80103cca:	75 04                	jne    80103cd0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103ccc:	c9                   	leave  
80103ccd:	c3                   	ret    
80103cce:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103cd0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103cd3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103cda:	00 00 00 
    iinit(ROOTDEV);
80103cdd:	6a 01                	push   $0x1
80103cdf:	e8 7c d8 ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103ce4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103ceb:	e8 f0 ee ff ff       	call   80102be0 <initlog>
80103cf0:	83 c4 10             	add    $0x10,%esp
}
80103cf3:	c9                   	leave  
80103cf4:	c3                   	ret    
80103cf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 1c             	sub    $0x1c,%esp
80103d09:	8b 45 08             	mov    0x8(%ebp),%eax
80103d0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103d0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pushcli();
80103d12:	e8 19 0a 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103d17:	e8 d4 fa ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103d1c:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103d22:	e8 49 0a 00 00       	call   80104770 <popcli>
  pushcli();
80103d27:	e8 04 0a 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103d2c:	e8 bf fa ff ff       	call   801037f0 <mycpu>
  t = c->thd;
80103d31:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
  popcli();
80103d37:	e8 34 0a 00 00       	call   80104770 <popcli>
  struct proc *curproc = myproc();
  struct thread *curthd = mythd();
  
  if(curproc == 0 || curthd == 0)
80103d3c:	85 ff                	test   %edi,%edi
80103d3e:	0f 84 a2 00 00 00    	je     80103de6 <sleep+0xe6>
80103d44:	85 f6                	test   %esi,%esi
80103d46:	0f 84 9a 00 00 00    	je     80103de6 <sleep+0xe6>
    panic("sleep");

  if(lk == 0)
80103d4c:	85 db                	test   %ebx,%ebx
80103d4e:	0f 84 85 00 00 00    	je     80103dd9 <sleep+0xd9>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d54:	81 fb 60 3d 11 80    	cmp    $0x80113d60,%ebx
80103d5a:	74 18                	je     80103d74 <sleep+0x74>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d5c:	83 ec 0c             	sub    $0xc,%esp
80103d5f:	68 60 3d 11 80       	push   $0x80113d60
80103d64:	e8 97 0a 00 00       	call   80104800 <acquire>
    release(lk);
80103d69:	89 1c 24             	mov    %ebx,(%esp)
80103d6c:	e8 4f 0b 00 00       	call   801048c0 <release>
80103d71:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  curthd->chan = chan;
80103d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  curthd->state = state;
80103d77:	c7 46 08 03 00 00 00 	movl   $0x3,0x8(%esi)
  curthd->chan = chan;
80103d7e:	89 46 1c             	mov    %eax,0x1c(%esi)
  if(curproc->state <= state){
80103d81:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103d85:	77 49                	ja     80103dd0 <sleep+0xd0>
    curproc->state = state;
80103d87:	c7 47 08 03 00 00 00 	movl   $0x3,0x8(%edi)
  setstate(curproc, curthd, SLEEPING);

  sched();
80103d8e:	e8 cd 3e 00 00       	call   80107c60 <sched>

  // Tidy up.
  curthd->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80103d93:	81 fb 60 3d 11 80    	cmp    $0x80113d60,%ebx
  curthd->chan = 0;
80103d99:	c7 46 1c 00 00 00 00 	movl   $0x0,0x1c(%esi)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80103da0:	74 26                	je     80103dc8 <sleep+0xc8>
    release(&ptable.lock);
80103da2:	83 ec 0c             	sub    $0xc,%esp
80103da5:	68 60 3d 11 80       	push   $0x80113d60
80103daa:	e8 11 0b 00 00       	call   801048c0 <release>
    acquire(lk);
80103daf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103db2:	83 c4 10             	add    $0x10,%esp
  }
}
80103db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103db8:	5b                   	pop    %ebx
80103db9:	5e                   	pop    %esi
80103dba:	5f                   	pop    %edi
80103dbb:	5d                   	pop    %ebp
    acquire(lk);
80103dbc:	e9 3f 0a 00 00       	jmp    80104800 <acquire>
80103dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80103dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dcb:	5b                   	pop    %ebx
80103dcc:	5e                   	pop    %esi
80103dcd:	5f                   	pop    %edi
80103dce:	5d                   	pop    %ebp
80103dcf:	c3                   	ret    
80103dd0:	89 f8                	mov    %edi,%eax
80103dd2:	e8 b9 f9 ff ff       	call   80103790 <setstate.part.0>
80103dd7:	eb b5                	jmp    80103d8e <sleep+0x8e>
    panic("sleep without lk");
80103dd9:	83 ec 0c             	sub    $0xc,%esp
80103ddc:	68 d6 89 10 80       	push   $0x801089d6
80103de1:	e8 9a c5 ff ff       	call   80100380 <panic>
    panic("sleep");
80103de6:	83 ec 0c             	sub    $0xc,%esp
80103de9:	68 d0 89 10 80       	push   $0x801089d0
80103dee:	e8 8d c5 ff ff       	call   80100380 <panic>
80103df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <wait>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e09:	e8 22 09 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103e0e:	e8 dd f9 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103e13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e19:	e8 52 09 00 00       	call   80104770 <popcli>
  acquire(&ptable.lock);
80103e1e:	83 ec 0c             	sub    $0xc,%esp
80103e21:	68 60 3d 11 80       	push   $0x80113d60
80103e26:	e8 d5 09 00 00       	call   80104800 <acquire>
80103e2b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103e2e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e30:	be 94 3d 11 80       	mov    $0x80113d94,%esi
80103e35:	eb 17                	jmp    80103e4e <wait+0x4e>
80103e37:	89 f6                	mov    %esi,%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103e40:	81 c6 8c 00 00 00    	add    $0x8c,%esi
80103e46:	81 fe 94 60 11 80    	cmp    $0x80116094,%esi
80103e4c:	73 1e                	jae    80103e6c <wait+0x6c>
      if(p->parent != curproc)
80103e4e:	39 5e 10             	cmp    %ebx,0x10(%esi)
80103e51:	75 ed                	jne    80103e40 <wait+0x40>
      if(p->state == ZOMBIE){
80103e53:	83 7e 08 01          	cmpl   $0x1,0x8(%esi)
80103e57:	74 47                	je     80103ea0 <wait+0xa0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e59:	81 c6 8c 00 00 00    	add    $0x8c,%esi
      havekids = 1;
80103e5f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e64:	81 fe 94 60 11 80    	cmp    $0x80116094,%esi
80103e6a:	72 e2                	jb     80103e4e <wait+0x4e>
    if(!havekids || curproc->killed || curproc->exited){
80103e6c:	85 c0                	test   %eax,%eax
80103e6e:	0f 84 0a 01 00 00    	je     80103f7e <wait+0x17e>
80103e74:	8b 53 14             	mov    0x14(%ebx),%edx
80103e77:	85 d2                	test   %edx,%edx
80103e79:	0f 85 ff 00 00 00    	jne    80103f7e <wait+0x17e>
80103e7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103e82:	85 c0                	test   %eax,%eax
80103e84:	0f 85 f4 00 00 00    	jne    80103f7e <wait+0x17e>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e8a:	83 ec 08             	sub    $0x8,%esp
80103e8d:	68 60 3d 11 80       	push   $0x80113d60
80103e92:	53                   	push   %ebx
80103e93:	e8 68 fe ff ff       	call   80103d00 <sleep>
    havekids = 0;
80103e98:	83 c4 10             	add    $0x10,%esp
80103e9b:	eb 91                	jmp    80103e2e <wait+0x2e>
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
        pid = p->pid;
80103ea0:	8b 7e 0c             	mov    0xc(%esi),%edi
        for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103ea3:	bb 94 60 11 80       	mov    $0x80116094,%ebx
80103ea8:	eb 11                	jmp    80103ebb <wait+0xbb>
80103eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103eb0:	83 c3 20             	add    $0x20,%ebx
80103eb3:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
80103eb9:	73 45                	jae    80103f00 <wait+0x100>
          if(t->mp == p){
80103ebb:	39 73 10             	cmp    %esi,0x10(%ebx)
80103ebe:	75 f0                	jne    80103eb0 <wait+0xb0>
            kfree(t->kstack);
80103ec0:	83 ec 0c             	sub    $0xc,%esp
80103ec3:	ff 73 04             	pushl  0x4(%ebx)
        for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103ec6:	83 c3 20             	add    $0x20,%ebx
            kfree(t->kstack);
80103ec9:	e8 22 e5 ff ff       	call   801023f0 <kfree>
            t->kstack = 0;
80103ece:	c7 43 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebx)
            t->usp = 0;
80103ed5:	c7 43 e0 00 00 00 00 	movl   $0x0,-0x20(%ebx)
            t->mp = 0;
80103edc:	83 c4 10             	add    $0x10,%esp
            t->state = UNUSED;
80103edf:	c7 43 e8 00 00 00 00 	movl   $0x0,-0x18(%ebx)
            t->tid = 0;
80103ee6:	c7 43 ec 00 00 00 00 	movl   $0x0,-0x14(%ebx)
            t->mp = 0;
80103eed:	c7 43 f0 00 00 00 00 	movl   $0x0,-0x10(%ebx)
        for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103ef4:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
80103efa:	72 bf                	jb     80103ebb <wait+0xbb>
80103efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        freevm(p->pgdir);
80103f00:	83 ec 0c             	sub    $0xc,%esp
80103f03:	ff 76 04             	pushl  0x4(%esi)
80103f06:	e8 75 35 00 00       	call   80107480 <freevm>
        release(&ptable.lock);
80103f0b:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
        p->pid = 0;
80103f12:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
        p->parent = 0;
80103f19:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
        p->name[0] = 0;
80103f20:	c6 46 60 00          	movb   $0x0,0x60(%esi)
        p->killed = 0;
80103f24:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
        p->state = UNUSED;
80103f2b:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
        p->stype = 0;
80103f32:	c7 46 70 00 00 00 00 	movl   $0x0,0x70(%esi)
        p->qlev = 0;
80103f39:	c7 46 74 00 00 00 00 	movl   $0x0,0x74(%esi)
        p->ticks = 0;
80103f40:	c7 46 78 00 00 00 00 	movl   $0x0,0x78(%esi)
        p->share = 0;
80103f47:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
        p->pass = 0;
80103f4e:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
80103f55:	00 00 00 
        p->fslist = 0;
80103f58:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80103f5f:	00 00 00 
        p->pin = 0;
80103f62:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80103f69:	00 00 00 
        release(&ptable.lock);
80103f6c:	e8 4f 09 00 00       	call   801048c0 <release>
        return pid;
80103f71:	83 c4 10             	add    $0x10,%esp
}
80103f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f77:	89 f8                	mov    %edi,%eax
80103f79:	5b                   	pop    %ebx
80103f7a:	5e                   	pop    %esi
80103f7b:	5f                   	pop    %edi
80103f7c:	5d                   	pop    %ebp
80103f7d:	c3                   	ret    
      release(&ptable.lock);
80103f7e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f81:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      release(&ptable.lock);
80103f86:	68 60 3d 11 80       	push   $0x80113d60
80103f8b:	e8 30 09 00 00       	call   801048c0 <release>
      return -1;
80103f90:	83 c4 10             	add    $0x10,%esp
80103f93:	eb df                	jmp    80103f74 <wait+0x174>
80103f95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
void
wakeup1(void *chan)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
80103fa5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct thread *t;

  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103fa8:	bb 94 60 11 80       	mov    $0x80116094,%ebx
80103fad:	eb 0c                	jmp    80103fbb <wakeup1+0x1b>
80103faf:	90                   	nop
80103fb0:	83 c3 20             	add    $0x20,%ebx
80103fb3:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
80103fb9:	73 2d                	jae    80103fe8 <wakeup1+0x48>
    if(t->state == SLEEPING && t->chan == chan)
80103fbb:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
80103fbf:	75 ef                	jne    80103fb0 <wakeup1+0x10>
80103fc1:	39 73 1c             	cmp    %esi,0x1c(%ebx)
80103fc4:	75 ea                	jne    80103fb0 <wakeup1+0x10>
      setstate(t->mp, t, RUNNABLE);
80103fc6:	8b 43 10             	mov    0x10(%ebx),%eax
  curthd->state = state;
80103fc9:	c7 43 08 05 00 00 00 	movl   $0x5,0x8(%ebx)
  if(curproc->state <= state){
80103fd0:	83 78 08 05          	cmpl   $0x5,0x8(%eax)
80103fd4:	77 1a                	ja     80103ff0 <wakeup1+0x50>
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103fd6:	83 c3 20             	add    $0x20,%ebx
    curproc->state = state;
80103fd9:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80103fe0:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
80103fe6:	72 d3                	jb     80103fbb <wakeup1+0x1b>
}
80103fe8:	5b                   	pop    %ebx
80103fe9:	5e                   	pop    %esi
80103fea:	5d                   	pop    %ebp
80103feb:	c3                   	ret    
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff0:	e8 9b f7 ff ff       	call   80103790 <setstate.part.0>
80103ff5:	eb b9                	jmp    80103fb0 <wakeup1+0x10>
80103ff7:	89 f6                	mov    %esi,%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <exit>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104009:	e8 22 07 00 00       	call   80104730 <pushcli>
  c = mycpu();
8010400e:	e8 dd f7 ff ff       	call   801037f0 <mycpu>
  t = c->thd;
80104013:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
8010401c:	e8 4f 07 00 00       	call   80104770 <popcli>
  pushcli();
80104021:	e8 0a 07 00 00       	call   80104730 <pushcli>
  c = mycpu();
80104026:	e8 c5 f7 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
8010402b:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104031:	e8 3a 07 00 00       	call   80104770 <popcli>
  if(curproc == initproc)
80104036:	39 35 d8 b5 10 80    	cmp    %esi,0x8010b5d8
8010403c:	0f 84 8f 00 00 00    	je     801040d1 <exit+0xd1>
80104042:	8d 7e 1c             	lea    0x1c(%esi),%edi
80104045:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80104048:	90                   	nop
80104049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104050:	8b 17                	mov    (%edi),%edx
80104052:	85 d2                	test   %edx,%edx
80104054:	74 12                	je     80104068 <exit+0x68>
      fileclose(curproc->ofile[fd]);
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	52                   	push   %edx
8010405a:	e8 c1 ce ff ff       	call   80100f20 <fileclose>
      curproc->ofile[fd] = 0;
8010405f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80104065:	83 c4 10             	add    $0x10,%esp
80104068:	83 c7 04             	add    $0x4,%edi
  for(fd = 0; fd < NOFILE; fd++){
8010406b:	39 fb                	cmp    %edi,%ebx
8010406d:	75 e1                	jne    80104050 <exit+0x50>
  begin_op();
8010406f:	e8 0c ec ff ff       	call   80102c80 <begin_op>
  iput(curproc->cwd);
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	ff 76 5c             	pushl  0x5c(%esi)
8010407a:	e8 11 d8 ff ff       	call   80101890 <iput>
  end_op();
8010407f:	e8 6c ec ff ff       	call   80102cf0 <end_op>
  curproc->cwd = 0;
80104084:	c7 46 5c 00 00 00 00 	movl   $0x0,0x5c(%esi)
  set_cpu_share(0);
8010408b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104092:	e8 a9 3d 00 00       	call   80107e40 <set_cpu_share>
  acquire(&ptable.lock);
80104097:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
8010409e:	e8 5d 07 00 00       	call   80104800 <acquire>
  if(allthdexit() == -1){
801040a3:	e8 38 3f 00 00       	call   80107fe0 <allthdexit>
801040a8:	83 c4 10             	add    $0x10,%esp
801040ab:	83 f8 ff             	cmp    $0xffffffff,%eax
801040ae:	75 2e                	jne    801040de <exit+0xde>
    cprintf("exit fail\n");
801040b0:	83 ec 0c             	sub    $0xc,%esp
801040b3:	68 f4 89 10 80       	push   $0x801089f4
801040b8:	e8 93 c5 ff ff       	call   80100650 <cprintf>
    release(&ptable.lock);
801040bd:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
801040c4:	e8 f7 07 00 00       	call   801048c0 <release>
}
801040c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040cc:	5b                   	pop    %ebx
801040cd:	5e                   	pop    %esi
801040ce:	5f                   	pop    %edi
801040cf:	5d                   	pop    %ebp
801040d0:	c3                   	ret    
    panic("init exiting");
801040d1:	83 ec 0c             	sub    $0xc,%esp
801040d4:	68 e7 89 10 80       	push   $0x801089e7
801040d9:	e8 a2 c2 ff ff       	call   80100380 <panic>
  wakeup1(curproc->parent);
801040de:	83 ec 0c             	sub    $0xc,%esp
801040e1:	ff 76 10             	pushl  0x10(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e4:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
  wakeup1(curproc->parent);
801040e9:	e8 b2 fe ff ff       	call   80103fa0 <wakeup1>
801040ee:	83 c4 10             	add    $0x10,%esp
801040f1:	eb 13                	jmp    80104106 <exit+0x106>
801040f3:	90                   	nop
801040f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801040fe:	81 fb 94 60 11 80    	cmp    $0x80116094,%ebx
80104104:	73 21                	jae    80104127 <exit+0x127>
    if(p->parent == curproc){
80104106:	39 73 10             	cmp    %esi,0x10(%ebx)
80104109:	75 ed                	jne    801040f8 <exit+0xf8>
      if(p->state == ZOMBIE)
8010410b:	83 7b 08 01          	cmpl   $0x1,0x8(%ebx)
      p->parent = initproc;
8010410f:	a1 d8 b5 10 80       	mov    0x8010b5d8,%eax
80104114:	89 43 10             	mov    %eax,0x10(%ebx)
      if(p->state == ZOMBIE)
80104117:	75 df                	jne    801040f8 <exit+0xf8>
        wakeup1(initproc);
80104119:	83 ec 0c             	sub    $0xc,%esp
8010411c:	50                   	push   %eax
8010411d:	e8 7e fe ff ff       	call   80103fa0 <wakeup1>
80104122:	83 c4 10             	add    $0x10,%esp
80104125:	eb d1                	jmp    801040f8 <exit+0xf8>
  curthd->state = state;
80104127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010412a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  if(curproc->state <= state){
80104131:	83 7e 08 01          	cmpl   $0x1,0x8(%esi)
80104135:	77 19                	ja     80104150 <exit+0x150>
    curproc->state = state;
80104137:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  sched();
8010413e:	e8 1d 3b 00 00       	call   80107c60 <sched>
  panic("zombie exit");
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	68 ff 89 10 80       	push   $0x801089ff
8010414b:	e8 30 c2 ff ff       	call   80100380 <panic>
80104150:	89 f0                	mov    %esi,%eax
80104152:	e8 39 f6 ff ff       	call   80103790 <setstate.part.0>
80104157:	eb e5                	jmp    8010413e <exit+0x13e>
80104159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104160 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010416a:	68 60 3d 11 80       	push   $0x80113d60
8010416f:	e8 8c 06 00 00       	call   80104800 <acquire>
  wakeup1(chan);
80104174:	89 1c 24             	mov    %ebx,(%esp)
80104177:	e8 24 fe ff ff       	call   80103fa0 <wakeup1>
  release(&ptable.lock);
8010417c:	83 c4 10             	add    $0x10,%esp
8010417f:	c7 45 08 60 3d 11 80 	movl   $0x80113d60,0x8(%ebp)
}
80104186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104189:	c9                   	leave  
  release(&ptable.lock);
8010418a:	e9 31 07 00 00       	jmp    801048c0 <release>
8010418f:	90                   	nop

80104190 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
  struct proc *p;
  struct thread *t;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104195:	be 94 3d 11 80       	mov    $0x80113d94,%esi
{
8010419a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010419d:	83 ec 0c             	sub    $0xc,%esp
801041a0:	68 60 3d 11 80       	push   $0x80113d60
801041a5:	e8 56 06 00 00       	call   80104800 <acquire>
801041aa:	83 c4 10             	add    $0x10,%esp
801041ad:	eb 0f                	jmp    801041be <kill+0x2e>
801041af:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b0:	81 c6 8c 00 00 00    	add    $0x8c,%esi
801041b6:	81 fe 94 60 11 80    	cmp    $0x80116094,%esi
801041bc:	73 7b                	jae    80104239 <kill+0xa9>
    if(p->pid == pid){
801041be:	39 5e 0c             	cmp    %ebx,0xc(%esi)
801041c1:	75 ed                	jne    801041b0 <kill+0x20>
      p->killed = 1;
801041c3:	c7 46 14 01 00 00 00 	movl   $0x1,0x14(%esi)
      // Wake process from sleep if necessary.
      for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
801041ca:	bb 94 60 11 80       	mov    $0x80116094,%ebx
801041cf:	eb 12                	jmp    801041e3 <kill+0x53>
801041d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041d8:	83 c3 20             	add    $0x20,%ebx
801041db:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
801041e1:	73 2a                	jae    8010420d <kill+0x7d>
        if(t->mp == p && t->state == SLEEPING)
801041e3:	39 73 10             	cmp    %esi,0x10(%ebx)
801041e6:	75 f0                	jne    801041d8 <kill+0x48>
801041e8:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
801041ec:	75 ea                	jne    801041d8 <kill+0x48>
  curthd->state = state;
801041ee:	c7 43 08 05 00 00 00 	movl   $0x5,0x8(%ebx)
  if(curproc->state <= state){
801041f5:	83 7e 08 05          	cmpl   $0x5,0x8(%esi)
801041f9:	77 35                	ja     80104230 <kill+0xa0>
      for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
801041fb:	83 c3 20             	add    $0x20,%ebx
    curproc->state = state;
801041fe:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
      for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80104205:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
8010420b:	72 d6                	jb     801041e3 <kill+0x53>
          setstate(p, t, RUNNABLE);
      release(&ptable.lock);
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 60 3d 11 80       	push   $0x80113d60
80104215:	e8 a6 06 00 00       	call   801048c0 <release>
      return 0;
8010421a:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
8010421d:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 0;
80104220:	31 c0                	xor    %eax,%eax
}
80104222:	5b                   	pop    %ebx
80104223:	5e                   	pop    %esi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret    
80104226:	8d 76 00             	lea    0x0(%esi),%esi
80104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104230:	89 f0                	mov    %esi,%eax
80104232:	e8 59 f5 ff ff       	call   80103790 <setstate.part.0>
80104237:	eb 9f                	jmp    801041d8 <kill+0x48>
  release(&ptable.lock);
80104239:	83 ec 0c             	sub    $0xc,%esp
8010423c:	68 60 3d 11 80       	push   $0x80113d60
80104241:	e8 7a 06 00 00       	call   801048c0 <release>
  return -1;
80104246:	83 c4 10             	add    $0x10,%esp
}
80104249:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
8010424c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104251:	5b                   	pop    %ebx
80104252:	5e                   	pop    %esi
80104253:	5d                   	pop    %ebp
80104254:	c3                   	ret    
80104255:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104260 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	57                   	push   %edi
80104264:	56                   	push   %esi
80104265:	53                   	push   %ebx
80104266:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104269:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
{
8010426e:	83 ec 3c             	sub    $0x3c,%esp
80104271:	eb 27                	jmp    8010429a <procdump+0x3a>
80104273:	90                   	nop
80104274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)mythd()->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104278:	83 ec 0c             	sub    $0xc,%esp
8010427b:	68 af 8d 10 80       	push   $0x80108daf
80104280:	e8 cb c3 ff ff       	call   80100650 <cprintf>
80104285:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104288:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010428e:	81 fb 94 60 11 80    	cmp    $0x80116094,%ebx
80104294:	0f 83 a6 00 00 00    	jae    80104340 <procdump+0xe0>
    if(p->state == UNUSED)
8010429a:	8b 43 08             	mov    0x8(%ebx),%eax
8010429d:	85 c0                	test   %eax,%eax
8010429f:	74 e7                	je     80104288 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042a1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801042a4:	ba 0b 8a 10 80       	mov    $0x80108a0b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042a9:	77 11                	ja     801042bc <procdump+0x5c>
801042ab:	8b 14 85 6c 8a 10 80 	mov    -0x7fef7594(,%eax,4),%edx
      state = "???";
801042b2:	b8 0b 8a 10 80       	mov    $0x80108a0b,%eax
801042b7:	85 d2                	test   %edx,%edx
801042b9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042bc:	8d 43 60             	lea    0x60(%ebx),%eax
801042bf:	50                   	push   %eax
801042c0:	52                   	push   %edx
801042c1:	ff 73 0c             	pushl  0xc(%ebx)
801042c4:	68 0f 8a 10 80       	push   $0x80108a0f
801042c9:	e8 82 c3 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
801042ce:	83 c4 10             	add    $0x10,%esp
801042d1:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
801042d5:	75 a1                	jne    80104278 <procdump+0x18>
  pushcli();
801042d7:	e8 54 04 00 00       	call   80104730 <pushcli>
  c = mycpu();
801042dc:	e8 0f f5 ff ff       	call   801037f0 <mycpu>
  t = c->thd;
801042e1:	8b b8 b0 00 00 00    	mov    0xb0(%eax),%edi
  popcli();
801042e7:	e8 84 04 00 00       	call   80104770 <popcli>
      getcallerpcs((uint*)mythd()->context->ebp+2, pc);
801042ec:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042ef:	83 ec 08             	sub    $0x8,%esp
801042f2:	50                   	push   %eax
801042f3:	8b 47 18             	mov    0x18(%edi),%eax
801042f6:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042f9:	8b 40 0c             	mov    0xc(%eax),%eax
801042fc:	83 c0 08             	add    $0x8,%eax
801042ff:	50                   	push   %eax
80104300:	e8 db 03 00 00       	call   801046e0 <getcallerpcs>
80104305:	83 c4 10             	add    $0x10,%esp
80104308:	90                   	nop
80104309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104310:	8b 17                	mov    (%edi),%edx
80104312:	85 d2                	test   %edx,%edx
80104314:	0f 84 5e ff ff ff    	je     80104278 <procdump+0x18>
        cprintf(" %p", pc[i]);
8010431a:	83 ec 08             	sub    $0x8,%esp
8010431d:	83 c7 04             	add    $0x4,%edi
80104320:	52                   	push   %edx
80104321:	68 81 84 10 80       	push   $0x80108481
80104326:	e8 25 c3 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010432b:	83 c4 10             	add    $0x10,%esp
8010432e:	39 fe                	cmp    %edi,%esi
80104330:	75 de                	jne    80104310 <procdump+0xb0>
80104332:	e9 41 ff ff ff       	jmp    80104278 <procdump+0x18>
80104337:	89 f6                	mov    %esi,%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
}
80104340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104343:	5b                   	pop    %ebx
80104344:	5e                   	pop    %esi
80104345:	5f                   	pop    %edi
80104346:	5d                   	pop    %ebp
80104347:	c3                   	ret    
80104348:	90                   	nop
80104349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104350 <xem_init>:

int xem_init(xem_t* semaphore) {
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	53                   	push   %ebx
80104356:	83 ec 18             	sub    $0x18,%esp
80104359:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&semaphore->lock);
8010435c:	8d 7b 08             	lea    0x8(%ebx),%edi
8010435f:	57                   	push   %edi
80104360:	e8 9b 04 00 00       	call   80104800 <acquire>

    if (semaphore->active == 0) {
80104365:	8b 73 04             	mov    0x4(%ebx),%esi
80104368:	83 c4 10             	add    $0x10,%esp
8010436b:	85 f6                	test   %esi,%esi
8010436d:	75 29                	jne    80104398 <xem_init+0x48>
    }
    else {
        return -1;
    }

    release(&semaphore->lock);
8010436f:	83 ec 0c             	sub    $0xc,%esp
        semaphore->active = 1;
80104372:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
        semaphore->value = 1;
80104379:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    release(&semaphore->lock);
8010437f:	57                   	push   %edi
80104380:	e8 3b 05 00 00       	call   801048c0 <release>
    return 0;
80104385:	83 c4 10             	add    $0x10,%esp
}
80104388:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010438b:	89 f0                	mov    %esi,%eax
8010438d:	5b                   	pop    %ebx
8010438e:	5e                   	pop    %esi
8010438f:	5f                   	pop    %edi
80104390:	5d                   	pop    %ebp
80104391:	c3                   	ret    
80104392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80104398:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010439d:	eb e9                	jmp    80104388 <xem_init+0x38>
8010439f:	90                   	nop

801043a0 <xem_wait>:

int xem_wait(xem_t* semaphore) {
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 10             	sub    $0x10,%esp
    acquire(&semaphore->lock);
801043a7:	8b 45 08             	mov    0x8(%ebp),%eax
801043aa:	83 c0 08             	add    $0x8,%eax
801043ad:	50                   	push   %eax
801043ae:	e8 4d 04 00 00       	call   80104800 <acquire>

    if (semaphore->value >= 1)
801043b3:	8b 45 08             	mov    0x8(%ebp),%eax
801043b6:	83 c4 10             	add    $0x10,%esp
801043b9:	8b 10                	mov    (%eax),%edx
801043bb:	85 d2                	test   %edx,%edx
801043bd:	7e 11                	jle    801043d0 <xem_wait+0x30>
        semaphore->value -= 1;
    else {
        while (semaphore->value < 1)
            sleep(&semaphore, &semaphore->lock);
        semaphore->value -= 1;
801043bf:	83 ea 01             	sub    $0x1,%edx
801043c2:	89 10                	mov    %edx,(%eax)
    }
    return 0;
}
801043c4:	31 c0                	xor    %eax,%eax
801043c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043c9:	c9                   	leave  
801043ca:	c3                   	ret    
801043cb:	90                   	nop
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            sleep(&semaphore, &semaphore->lock);
801043d0:	8d 5d 08             	lea    0x8(%ebp),%ebx
801043d3:	90                   	nop
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d8:	83 ec 08             	sub    $0x8,%esp
801043db:	83 c0 08             	add    $0x8,%eax
801043de:	50                   	push   %eax
801043df:	53                   	push   %ebx
801043e0:	e8 1b f9 ff ff       	call   80103d00 <sleep>
        while (semaphore->value < 1)
801043e5:	8b 45 08             	mov    0x8(%ebp),%eax
801043e8:	83 c4 10             	add    $0x10,%esp
801043eb:	8b 10                	mov    (%eax),%edx
801043ed:	85 d2                	test   %edx,%edx
801043ef:	7e e7                	jle    801043d8 <xem_wait+0x38>
        semaphore->value -= 1;
801043f1:	83 ea 01             	sub    $0x1,%edx
801043f4:	89 10                	mov    %edx,(%eax)
}
801043f6:	31 c0                	xor    %eax,%eax
801043f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043fb:	c9                   	leave  
801043fc:	c3                   	ret    
801043fd:	8d 76 00             	lea    0x0(%esi),%esi

80104400 <xem_unlock>:

int xem_unlock(xem_t* semaphore) {
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&semaphore->lock);
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	8d 5e 08             	lea    0x8(%esi),%ebx
8010440e:	53                   	push   %ebx
8010440f:	e8 ec 03 00 00       	call   80104800 <acquire>
    semaphore->active = 0;
80104414:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    release(&semaphore->lock);
8010441b:	89 1c 24             	mov    %ebx,(%esp)
8010441e:	e8 9d 04 00 00       	call   801048c0 <release>

    return 0;
}
80104423:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104426:	31 c0                	xor    %eax,%eax
80104428:	5b                   	pop    %ebx
80104429:	5e                   	pop    %esi
8010442a:	5d                   	pop    %ebp
8010442b:	c3                   	ret    
8010442c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104430 <rwlock_init>:

int rwlock_init(rwlock_t* rwlock) {
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 10             	sub    $0x10,%esp
80104437:	8b 5d 08             	mov    0x8(%ebp),%ebx
    rwlock->readers = 0;
8010443a:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
    xem_init(&rwlock->lock);
80104441:	53                   	push   %ebx
    xem_init(&rwlock->writelock);
80104442:	83 c3 3c             	add    $0x3c,%ebx
    xem_init(&rwlock->lock);
80104445:	e8 06 ff ff ff       	call   80104350 <xem_init>
    xem_init(&rwlock->writelock);
8010444a:	89 1c 24             	mov    %ebx,(%esp)
8010444d:	e8 fe fe ff ff       	call   80104350 <xem_init>

    return 0;
}
80104452:	31 c0                	xor    %eax,%eax
80104454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104457:	c9                   	leave  
80104458:	c3                   	ret    
80104459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104460 <rwlock_acquire_readlock>:

int rwlock_acquire_readlock(rwlock_t* rwlock) {
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	8b 5d 08             	mov    0x8(%ebp),%ebx
    xem_wait(&rwlock->lock);
80104468:	83 ec 0c             	sub    $0xc,%esp
8010446b:	53                   	push   %ebx
8010446c:	e8 2f ff ff ff       	call   801043a0 <xem_wait>
    rwlock->readers++;
80104471:	8b 43 78             	mov    0x78(%ebx),%eax
    if (rwlock->readers == 1)
80104474:	83 c4 10             	add    $0x10,%esp
    rwlock->readers++;
80104477:	83 c0 01             	add    $0x1,%eax
    if (rwlock->readers == 1)
8010447a:	83 f8 01             	cmp    $0x1,%eax
    rwlock->readers++;
8010447d:	89 43 78             	mov    %eax,0x78(%ebx)
    if (rwlock->readers == 1)
80104480:	74 2e                	je     801044b0 <rwlock_acquire_readlock+0x50>
    acquire(&semaphore->lock);
80104482:	8d 73 08             	lea    0x8(%ebx),%esi
80104485:	83 ec 0c             	sub    $0xc,%esp
80104488:	56                   	push   %esi
80104489:	e8 72 03 00 00       	call   80104800 <acquire>
    semaphore->active = 0;
8010448e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    release(&semaphore->lock);
80104495:	89 34 24             	mov    %esi,(%esp)
80104498:	e8 23 04 00 00       	call   801048c0 <release>
        xem_wait(&rwlock->writelock);
    xem_unlock(&rwlock->lock);

    return 0;
}
8010449d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a0:	31 c0                	xor    %eax,%eax
801044a2:	5b                   	pop    %ebx
801044a3:	5e                   	pop    %esi
801044a4:	5d                   	pop    %ebp
801044a5:	c3                   	ret    
801044a6:	8d 76 00             	lea    0x0(%esi),%esi
801044a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        xem_wait(&rwlock->writelock);
801044b0:	8d 43 3c             	lea    0x3c(%ebx),%eax
801044b3:	83 ec 0c             	sub    $0xc,%esp
801044b6:	50                   	push   %eax
801044b7:	e8 e4 fe ff ff       	call   801043a0 <xem_wait>
801044bc:	83 c4 10             	add    $0x10,%esp
801044bf:	eb c1                	jmp    80104482 <rwlock_acquire_readlock+0x22>
801044c1:	eb 0d                	jmp    801044d0 <rwlock_acquire_writelock>
801044c3:	90                   	nop
801044c4:	90                   	nop
801044c5:	90                   	nop
801044c6:	90                   	nop
801044c7:	90                   	nop
801044c8:	90                   	nop
801044c9:	90                   	nop
801044ca:	90                   	nop
801044cb:	90                   	nop
801044cc:	90                   	nop
801044cd:	90                   	nop
801044ce:	90                   	nop
801044cf:	90                   	nop

801044d0 <rwlock_acquire_writelock>:

int rwlock_acquire_writelock(rwlock_t* rwlock) {
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	83 ec 14             	sub    $0x14,%esp
    xem_wait(&rwlock->writelock);
801044d6:	8b 45 08             	mov    0x8(%ebp),%eax
801044d9:	83 c0 3c             	add    $0x3c,%eax
801044dc:	50                   	push   %eax
801044dd:	e8 be fe ff ff       	call   801043a0 <xem_wait>

    return 0;
}
801044e2:	31 c0                	xor    %eax,%eax
801044e4:	c9                   	leave  
801044e5:	c3                   	ret    
801044e6:	8d 76 00             	lea    0x0(%esi),%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044f0 <rwlock_release_readlock>:

int rwlock_release_readlock(rwlock_t* rwlock) {
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
801044f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    xem_wait(&rwlock->lock);
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	53                   	push   %ebx
801044fc:	e8 9f fe ff ff       	call   801043a0 <xem_wait>
    rwlock->readers--;
80104501:	8b 43 78             	mov    0x78(%ebx),%eax
    if (rwlock->readers == 0)
80104504:	83 c4 10             	add    $0x10,%esp
    rwlock->readers--;
80104507:	83 e8 01             	sub    $0x1,%eax
    if (rwlock->readers == 0)
8010450a:	85 c0                	test   %eax,%eax
    rwlock->readers--;
8010450c:	89 43 78             	mov    %eax,0x78(%ebx)
    if (rwlock->readers == 0)
8010450f:	75 1e                	jne    8010452f <rwlock_release_readlock+0x3f>
    acquire(&semaphore->lock);
80104511:	8d 73 44             	lea    0x44(%ebx),%esi
80104514:	83 ec 0c             	sub    $0xc,%esp
80104517:	56                   	push   %esi
80104518:	e8 e3 02 00 00       	call   80104800 <acquire>
    semaphore->active = 0;
8010451d:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
    release(&semaphore->lock);
80104524:	89 34 24             	mov    %esi,(%esp)
80104527:	e8 94 03 00 00       	call   801048c0 <release>
8010452c:	83 c4 10             	add    $0x10,%esp
    acquire(&semaphore->lock);
8010452f:	8d 73 08             	lea    0x8(%ebx),%esi
80104532:	83 ec 0c             	sub    $0xc,%esp
80104535:	56                   	push   %esi
80104536:	e8 c5 02 00 00       	call   80104800 <acquire>
    semaphore->active = 0;
8010453b:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    release(&semaphore->lock);
80104542:	89 34 24             	mov    %esi,(%esp)
80104545:	e8 76 03 00 00       	call   801048c0 <release>
        xem_unlock(&rwlock->writelock);
    xem_unlock(&rwlock->lock);

    return 0;
}
8010454a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010454d:	31 c0                	xor    %eax,%eax
8010454f:	5b                   	pop    %ebx
80104550:	5e                   	pop    %esi
80104551:	5d                   	pop    %ebp
80104552:	c3                   	ret    
80104553:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <rwlock_relaese_writelock>:

int rwlock_relaese_writelock(rwlock_t* rwlock) {
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&semaphore->lock);
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	8d 5e 44             	lea    0x44(%esi),%ebx
8010456e:	53                   	push   %ebx
8010456f:	e8 8c 02 00 00       	call   80104800 <acquire>
    semaphore->active = 0;
80104574:	c7 46 40 00 00 00 00 	movl   $0x0,0x40(%esi)
    release(&semaphore->lock);
8010457b:	89 1c 24             	mov    %ebx,(%esp)
8010457e:	e8 3d 03 00 00       	call   801048c0 <release>
    xem_unlock(&rwlock->writelock);

    return 0;
}
80104583:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104586:	31 c0                	xor    %eax,%eax
80104588:	5b                   	pop    %ebx
80104589:	5e                   	pop    %esi
8010458a:	5d                   	pop    %ebp
8010458b:	c3                   	ret    
8010458c:	66 90                	xchg   %ax,%ax
8010458e:	66 90                	xchg   %ax,%ax

80104590 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010459a:	68 84 8a 10 80       	push   $0x80108a84
8010459f:	8d 43 04             	lea    0x4(%ebx),%eax
801045a2:	50                   	push   %eax
801045a3:	e8 18 01 00 00       	call   801046c0 <initlock>
  lk->name = name;
801045a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c1:	c9                   	leave  
801045c2:	c3                   	ret    
801045c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	8d 73 04             	lea    0x4(%ebx),%esi
801045de:	56                   	push   %esi
801045df:	e8 1c 02 00 00       	call   80104800 <acquire>
  while (lk->locked) {
801045e4:	8b 13                	mov    (%ebx),%edx
801045e6:	83 c4 10             	add    $0x10,%esp
801045e9:	85 d2                	test   %edx,%edx
801045eb:	74 16                	je     80104603 <acquiresleep+0x33>
801045ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045f0:	83 ec 08             	sub    $0x8,%esp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	e8 06 f7 ff ff       	call   80103d00 <sleep>
  while (lk->locked) {
801045fa:	8b 03                	mov    (%ebx),%eax
801045fc:	83 c4 10             	add    $0x10,%esp
801045ff:	85 c0                	test   %eax,%eax
80104601:	75 ed                	jne    801045f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104603:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104609:	e8 82 f2 ff ff       	call   80103890 <myproc>
8010460e:	8b 40 0c             	mov    0xc(%eax),%eax
80104611:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104614:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104617:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010461a:	5b                   	pop    %ebx
8010461b:	5e                   	pop    %esi
8010461c:	5d                   	pop    %ebp
  release(&lk->lk);
8010461d:	e9 9e 02 00 00       	jmp    801048c0 <release>
80104622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	8d 73 04             	lea    0x4(%ebx),%esi
8010463e:	56                   	push   %esi
8010463f:	e8 bc 01 00 00       	call   80104800 <acquire>
  lk->locked = 0;
80104644:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010464a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104651:	89 1c 24             	mov    %ebx,(%esp)
80104654:	e8 07 fb ff ff       	call   80104160 <wakeup>
  release(&lk->lk);
80104659:	89 75 08             	mov    %esi,0x8(%ebp)
8010465c:	83 c4 10             	add    $0x10,%esp
}
8010465f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104662:	5b                   	pop    %ebx
80104663:	5e                   	pop    %esi
80104664:	5d                   	pop    %ebp
  release(&lk->lk);
80104665:	e9 56 02 00 00       	jmp    801048c0 <release>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104670 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	56                   	push   %esi
80104675:	53                   	push   %ebx
80104676:	31 ff                	xor    %edi,%edi
80104678:	83 ec 18             	sub    $0x18,%esp
8010467b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010467e:	8d 73 04             	lea    0x4(%ebx),%esi
80104681:	56                   	push   %esi
80104682:	e8 79 01 00 00       	call   80104800 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104687:	8b 03                	mov    (%ebx),%eax
80104689:	83 c4 10             	add    $0x10,%esp
8010468c:	85 c0                	test   %eax,%eax
8010468e:	74 13                	je     801046a3 <holdingsleep+0x33>
80104690:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104693:	e8 f8 f1 ff ff       	call   80103890 <myproc>
80104698:	39 58 0c             	cmp    %ebx,0xc(%eax)
8010469b:	0f 94 c0             	sete   %al
8010469e:	0f b6 c0             	movzbl %al,%eax
801046a1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801046a3:	83 ec 0c             	sub    $0xc,%esp
801046a6:	56                   	push   %esi
801046a7:	e8 14 02 00 00       	call   801048c0 <release>
  return r;
}
801046ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046af:	89 f8                	mov    %edi,%eax
801046b1:	5b                   	pop    %ebx
801046b2:	5e                   	pop    %esi
801046b3:	5f                   	pop    %edi
801046b4:	5d                   	pop    %ebp
801046b5:	c3                   	ret    
801046b6:	66 90                	xchg   %ax,%ax
801046b8:	66 90                	xchg   %ax,%ax
801046ba:	66 90                	xchg   %ax,%ax
801046bc:	66 90                	xchg   %ax,%ax
801046be:	66 90                	xchg   %ax,%ax

801046c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046e1:	31 d2                	xor    %edx,%edx
{
801046e3:	89 e5                	mov    %esp,%ebp
801046e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046ec:	83 e8 08             	sub    $0x8,%eax
801046ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046fc:	77 1a                	ja     80104718 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104701:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104704:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104707:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104709:	83 fa 0a             	cmp    $0xa,%edx
8010470c:	75 e2                	jne    801046f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010470e:	5b                   	pop    %ebx
8010470f:	5d                   	pop    %ebp
80104710:	c3                   	ret    
80104711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104718:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010471b:	83 c1 28             	add    $0x28,%ecx
8010471e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104726:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104729:	39 c1                	cmp    %eax,%ecx
8010472b:	75 f3                	jne    80104720 <getcallerpcs+0x40>
}
8010472d:	5b                   	pop    %ebx
8010472e:	5d                   	pop    %ebp
8010472f:	c3                   	ret    

80104730 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 04             	sub    $0x4,%esp
80104737:	9c                   	pushf  
80104738:	5b                   	pop    %ebx
  asm volatile("cli");
80104739:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010473a:	e8 b1 f0 ff ff       	call   801037f0 <mycpu>
8010473f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104745:	85 c0                	test   %eax,%eax
80104747:	75 11                	jne    8010475a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104749:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010474f:	e8 9c f0 ff ff       	call   801037f0 <mycpu>
80104754:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010475a:	e8 91 f0 ff ff       	call   801037f0 <mycpu>
8010475f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104766:	83 c4 04             	add    $0x4,%esp
80104769:	5b                   	pop    %ebx
8010476a:	5d                   	pop    %ebp
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104770 <popcli>:

void
popcli(void)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104776:	9c                   	pushf  
80104777:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104778:	f6 c4 02             	test   $0x2,%ah
8010477b:	75 35                	jne    801047b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010477d:	e8 6e f0 ff ff       	call   801037f0 <mycpu>
80104782:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104789:	78 34                	js     801047bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010478b:	e8 60 f0 ff ff       	call   801037f0 <mycpu>
80104790:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104796:	85 d2                	test   %edx,%edx
80104798:	74 06                	je     801047a0 <popcli+0x30>
    sti();
}
8010479a:	c9                   	leave  
8010479b:	c3                   	ret    
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047a0:	e8 4b f0 ff ff       	call   801037f0 <mycpu>
801047a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047ab:	85 c0                	test   %eax,%eax
801047ad:	74 eb                	je     8010479a <popcli+0x2a>
  asm volatile("sti");
801047af:	fb                   	sti    
}
801047b0:	c9                   	leave  
801047b1:	c3                   	ret    
    panic("popcli - interruptible");
801047b2:	83 ec 0c             	sub    $0xc,%esp
801047b5:	68 8f 8a 10 80       	push   $0x80108a8f
801047ba:	e8 c1 bb ff ff       	call   80100380 <panic>
    panic("popcli");
801047bf:	83 ec 0c             	sub    $0xc,%esp
801047c2:	68 a6 8a 10 80       	push   $0x80108aa6
801047c7:	e8 b4 bb ff ff       	call   80100380 <panic>
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <holding>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 75 08             	mov    0x8(%ebp),%esi
801047d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047da:	e8 51 ff ff ff       	call   80104730 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047df:	8b 06                	mov    (%esi),%eax
801047e1:	85 c0                	test   %eax,%eax
801047e3:	74 10                	je     801047f5 <holding+0x25>
801047e5:	8b 5e 08             	mov    0x8(%esi),%ebx
801047e8:	e8 03 f0 ff ff       	call   801037f0 <mycpu>
801047ed:	39 c3                	cmp    %eax,%ebx
801047ef:	0f 94 c3             	sete   %bl
801047f2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801047f5:	e8 76 ff ff ff       	call   80104770 <popcli>
}
801047fa:	89 d8                	mov    %ebx,%eax
801047fc:	5b                   	pop    %ebx
801047fd:	5e                   	pop    %esi
801047fe:	5d                   	pop    %ebp
801047ff:	c3                   	ret    

80104800 <acquire>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104805:	e8 26 ff ff ff       	call   80104730 <pushcli>
  if(holding(lk))
8010480a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010480d:	83 ec 0c             	sub    $0xc,%esp
80104810:	53                   	push   %ebx
80104811:	e8 ba ff ff ff       	call   801047d0 <holding>
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	85 c0                	test   %eax,%eax
8010481b:	0f 85 83 00 00 00    	jne    801048a4 <acquire+0xa4>
80104821:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104823:	ba 01 00 00 00       	mov    $0x1,%edx
80104828:	eb 09                	jmp    80104833 <acquire+0x33>
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104830:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104833:	89 d0                	mov    %edx,%eax
80104835:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104838:	85 c0                	test   %eax,%eax
8010483a:	75 f4                	jne    80104830 <acquire+0x30>
  __sync_synchronize();
8010483c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104841:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104844:	e8 a7 ef ff ff       	call   801037f0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104849:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010484c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010484f:	89 e8                	mov    %ebp,%eax
80104851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104858:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010485e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104864:	77 1a                	ja     80104880 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104866:	8b 48 04             	mov    0x4(%eax),%ecx
80104869:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010486c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010486f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104871:	83 fe 0a             	cmp    $0xa,%esi
80104874:	75 e2                	jne    80104858 <acquire+0x58>
}
80104876:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104879:	5b                   	pop    %ebx
8010487a:	5e                   	pop    %esi
8010487b:	5d                   	pop    %ebp
8010487c:	c3                   	ret    
8010487d:	8d 76 00             	lea    0x0(%esi),%esi
80104880:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104883:	83 c2 28             	add    $0x28,%edx
80104886:	8d 76 00             	lea    0x0(%esi),%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104896:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104899:	39 d0                	cmp    %edx,%eax
8010489b:	75 f3                	jne    80104890 <acquire+0x90>
}
8010489d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048a0:	5b                   	pop    %ebx
801048a1:	5e                   	pop    %esi
801048a2:	5d                   	pop    %ebp
801048a3:	c3                   	ret    
    panic("acquire");
801048a4:	83 ec 0c             	sub    $0xc,%esp
801048a7:	68 ad 8a 10 80       	push   $0x80108aad
801048ac:	e8 cf ba ff ff       	call   80100380 <panic>
801048b1:	eb 0d                	jmp    801048c0 <release>
801048b3:	90                   	nop
801048b4:	90                   	nop
801048b5:	90                   	nop
801048b6:	90                   	nop
801048b7:	90                   	nop
801048b8:	90                   	nop
801048b9:	90                   	nop
801048ba:	90                   	nop
801048bb:	90                   	nop
801048bc:	90                   	nop
801048bd:	90                   	nop
801048be:	90                   	nop
801048bf:	90                   	nop

801048c0 <release>:
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 10             	sub    $0x10,%esp
801048c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801048ca:	53                   	push   %ebx
801048cb:	e8 00 ff ff ff       	call   801047d0 <holding>
801048d0:	83 c4 10             	add    $0x10,%esp
801048d3:	85 c0                	test   %eax,%eax
801048d5:	74 22                	je     801048f9 <release+0x39>
  lk->pcs[0] = 0;
801048d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048e5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f3:	c9                   	leave  
  popcli();
801048f4:	e9 77 fe ff ff       	jmp    80104770 <popcli>
    panic("release");
801048f9:	83 ec 0c             	sub    $0xc,%esp
801048fc:	68 b5 8a 10 80       	push   $0x80108ab5
80104901:	e8 7a ba ff ff       	call   80100380 <panic>
80104906:	66 90                	xchg   %ax,%ax
80104908:	66 90                	xchg   %ax,%ax
8010490a:	66 90                	xchg   %ax,%ax
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	53                   	push   %ebx
80104915:	8b 55 08             	mov    0x8(%ebp),%edx
80104918:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010491b:	f6 c2 03             	test   $0x3,%dl
8010491e:	75 05                	jne    80104925 <memset+0x15>
80104920:	f6 c1 03             	test   $0x3,%cl
80104923:	74 13                	je     80104938 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104925:	89 d7                	mov    %edx,%edi
80104927:	8b 45 0c             	mov    0xc(%ebp),%eax
8010492a:	fc                   	cld    
8010492b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010492d:	5b                   	pop    %ebx
8010492e:	89 d0                	mov    %edx,%eax
80104930:	5f                   	pop    %edi
80104931:	5d                   	pop    %ebp
80104932:	c3                   	ret    
80104933:	90                   	nop
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104938:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010493c:	c1 e9 02             	shr    $0x2,%ecx
8010493f:	89 f8                	mov    %edi,%eax
80104941:	89 fb                	mov    %edi,%ebx
80104943:	c1 e0 18             	shl    $0x18,%eax
80104946:	c1 e3 10             	shl    $0x10,%ebx
80104949:	09 d8                	or     %ebx,%eax
8010494b:	09 f8                	or     %edi,%eax
8010494d:	c1 e7 08             	shl    $0x8,%edi
80104950:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104952:	89 d7                	mov    %edx,%edi
80104954:	fc                   	cld    
80104955:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104957:	5b                   	pop    %ebx
80104958:	89 d0                	mov    %edx,%eax
8010495a:	5f                   	pop    %edi
8010495b:	5d                   	pop    %ebp
8010495c:	c3                   	ret    
8010495d:	8d 76 00             	lea    0x0(%esi),%esi

80104960 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	53                   	push   %ebx
80104966:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104969:	8b 75 08             	mov    0x8(%ebp),%esi
8010496c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010496f:	85 db                	test   %ebx,%ebx
80104971:	74 29                	je     8010499c <memcmp+0x3c>
    if(*s1 != *s2)
80104973:	0f b6 16             	movzbl (%esi),%edx
80104976:	0f b6 0f             	movzbl (%edi),%ecx
80104979:	38 d1                	cmp    %dl,%cl
8010497b:	75 2b                	jne    801049a8 <memcmp+0x48>
8010497d:	b8 01 00 00 00       	mov    $0x1,%eax
80104982:	eb 14                	jmp    80104998 <memcmp+0x38>
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104988:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010498c:	83 c0 01             	add    $0x1,%eax
8010498f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104994:	38 ca                	cmp    %cl,%dl
80104996:	75 10                	jne    801049a8 <memcmp+0x48>
  while(n-- > 0){
80104998:	39 d8                	cmp    %ebx,%eax
8010499a:	75 ec                	jne    80104988 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010499c:	5b                   	pop    %ebx
  return 0;
8010499d:	31 c0                	xor    %eax,%eax
}
8010499f:	5e                   	pop    %esi
801049a0:	5f                   	pop    %edi
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret    
801049a3:	90                   	nop
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801049a8:	0f b6 c2             	movzbl %dl,%eax
}
801049ab:	5b                   	pop    %ebx
      return *s1 - *s2;
801049ac:	29 c8                	sub    %ecx,%eax
}
801049ae:	5e                   	pop    %esi
801049af:	5f                   	pop    %edi
801049b0:	5d                   	pop    %ebp
801049b1:	c3                   	ret    
801049b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	8b 45 08             	mov    0x8(%ebp),%eax
801049c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049cb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049ce:	39 c3                	cmp    %eax,%ebx
801049d0:	73 26                	jae    801049f8 <memmove+0x38>
801049d2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801049d5:	39 c8                	cmp    %ecx,%eax
801049d7:	73 1f                	jae    801049f8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801049d9:	85 f6                	test   %esi,%esi
801049db:	8d 56 ff             	lea    -0x1(%esi),%edx
801049de:	74 0f                	je     801049ef <memmove+0x2f>
      *--d = *--s;
801049e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801049e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801049e7:	83 ea 01             	sub    $0x1,%edx
801049ea:	83 fa ff             	cmp    $0xffffffff,%edx
801049ed:	75 f1                	jne    801049e0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049ef:	5b                   	pop    %ebx
801049f0:	5e                   	pop    %esi
801049f1:	5d                   	pop    %ebp
801049f2:	c3                   	ret    
801049f3:	90                   	nop
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801049f8:	31 d2                	xor    %edx,%edx
801049fa:	85 f6                	test   %esi,%esi
801049fc:	74 f1                	je     801049ef <memmove+0x2f>
801049fe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a00:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a04:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a07:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a0a:	39 d6                	cmp    %edx,%esi
80104a0c:	75 f2                	jne    80104a00 <memmove+0x40>
}
80104a0e:	5b                   	pop    %ebx
80104a0f:	5e                   	pop    %esi
80104a10:	5d                   	pop    %ebp
80104a11:	c3                   	ret    
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a20 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a23:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a24:	eb 9a                	jmp    801049c0 <memmove>
80104a26:	8d 76 00             	lea    0x0(%esi),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a38:	53                   	push   %ebx
80104a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a3f:	85 ff                	test   %edi,%edi
80104a41:	74 2f                	je     80104a72 <strncmp+0x42>
80104a43:	0f b6 01             	movzbl (%ecx),%eax
80104a46:	0f b6 1e             	movzbl (%esi),%ebx
80104a49:	84 c0                	test   %al,%al
80104a4b:	74 37                	je     80104a84 <strncmp+0x54>
80104a4d:	38 c3                	cmp    %al,%bl
80104a4f:	75 33                	jne    80104a84 <strncmp+0x54>
80104a51:	01 f7                	add    %esi,%edi
80104a53:	eb 13                	jmp    80104a68 <strncmp+0x38>
80104a55:	8d 76 00             	lea    0x0(%esi),%esi
80104a58:	0f b6 01             	movzbl (%ecx),%eax
80104a5b:	84 c0                	test   %al,%al
80104a5d:	74 21                	je     80104a80 <strncmp+0x50>
80104a5f:	0f b6 1a             	movzbl (%edx),%ebx
80104a62:	89 d6                	mov    %edx,%esi
80104a64:	38 d8                	cmp    %bl,%al
80104a66:	75 1c                	jne    80104a84 <strncmp+0x54>
    n--, p++, q++;
80104a68:	8d 56 01             	lea    0x1(%esi),%edx
80104a6b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a6e:	39 fa                	cmp    %edi,%edx
80104a70:	75 e6                	jne    80104a58 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104a72:	5b                   	pop    %ebx
    return 0;
80104a73:	31 c0                	xor    %eax,%eax
}
80104a75:	5e                   	pop    %esi
80104a76:	5f                   	pop    %edi
80104a77:	5d                   	pop    %ebp
80104a78:	c3                   	ret    
80104a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a80:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104a84:	29 d8                	sub    %ebx,%eax
}
80104a86:	5b                   	pop    %ebx
80104a87:	5e                   	pop    %esi
80104a88:	5f                   	pop    %edi
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret    
80104a8b:	90                   	nop
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
80104a95:	8b 45 08             	mov    0x8(%ebp),%eax
80104a98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a9e:	89 c2                	mov    %eax,%edx
80104aa0:	eb 19                	jmp    80104abb <strncpy+0x2b>
80104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa8:	83 c3 01             	add    $0x1,%ebx
80104aab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104aaf:	83 c2 01             	add    $0x1,%edx
80104ab2:	84 c9                	test   %cl,%cl
80104ab4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ab7:	74 09                	je     80104ac2 <strncpy+0x32>
80104ab9:	89 f1                	mov    %esi,%ecx
80104abb:	85 c9                	test   %ecx,%ecx
80104abd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ac0:	7f e6                	jg     80104aa8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ac2:	31 c9                	xor    %ecx,%ecx
80104ac4:	85 f6                	test   %esi,%esi
80104ac6:	7e 17                	jle    80104adf <strncpy+0x4f>
80104ac8:	90                   	nop
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ad0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ad4:	89 f3                	mov    %esi,%ebx
80104ad6:	83 c1 01             	add    $0x1,%ecx
80104ad9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104adb:	85 db                	test   %ebx,%ebx
80104add:	7f f1                	jg     80104ad0 <strncpy+0x40>
  return os;
}
80104adf:	5b                   	pop    %ebx
80104ae0:	5e                   	pop    %esi
80104ae1:	5d                   	pop    %ebp
80104ae2:	c3                   	ret    
80104ae3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104af8:	8b 45 08             	mov    0x8(%ebp),%eax
80104afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104afe:	85 c9                	test   %ecx,%ecx
80104b00:	7e 26                	jle    80104b28 <safestrcpy+0x38>
80104b02:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b06:	89 c1                	mov    %eax,%ecx
80104b08:	eb 17                	jmp    80104b21 <safestrcpy+0x31>
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b10:	83 c2 01             	add    $0x1,%edx
80104b13:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b17:	83 c1 01             	add    $0x1,%ecx
80104b1a:	84 db                	test   %bl,%bl
80104b1c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b1f:	74 04                	je     80104b25 <safestrcpy+0x35>
80104b21:	39 f2                	cmp    %esi,%edx
80104b23:	75 eb                	jne    80104b10 <safestrcpy+0x20>
    ;
  *s = 0;
80104b25:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b28:	5b                   	pop    %ebx
80104b29:	5e                   	pop    %esi
80104b2a:	5d                   	pop    %ebp
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b30 <strlen>:

int
strlen(const char *s)
{
80104b30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b31:	31 c0                	xor    %eax,%eax
{
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b38:	80 3a 00             	cmpb   $0x0,(%edx)
80104b3b:	74 0c                	je     80104b49 <strlen+0x19>
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
80104b40:	83 c0 01             	add    $0x1,%eax
80104b43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b47:	75 f7                	jne    80104b40 <strlen+0x10>
    ;
  return n;
}
80104b49:	5d                   	pop    %ebp
80104b4a:	c3                   	ret    

80104b4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b53:	55                   	push   %ebp
  pushl %ebx
80104b54:	53                   	push   %ebx
  pushl %esi
80104b55:	56                   	push   %esi
  pushl %edi
80104b56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b5b:	5f                   	pop    %edi
  popl %esi
80104b5c:	5e                   	pop    %esi
  popl %ebx
80104b5d:	5b                   	pop    %ebx
  popl %ebp
80104b5e:	5d                   	pop    %ebp
  ret
80104b5f:	c3                   	ret    

80104b60 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
80104b64:	83 ec 04             	sub    $0x4,%esp
80104b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b6a:	e8 21 ed ff ff       	call   80103890 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b6f:	8b 00                	mov    (%eax),%eax
80104b71:	39 d8                	cmp    %ebx,%eax
80104b73:	76 1b                	jbe    80104b90 <fetchint+0x30>
80104b75:	8d 53 04             	lea    0x4(%ebx),%edx
80104b78:	39 d0                	cmp    %edx,%eax
80104b7a:	72 14                	jb     80104b90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b7f:	8b 13                	mov    (%ebx),%edx
80104b81:	89 10                	mov    %edx,(%eax)
  return 0;
80104b83:	31 c0                	xor    %eax,%eax
}
80104b85:	83 c4 04             	add    $0x4,%esp
80104b88:	5b                   	pop    %ebx
80104b89:	5d                   	pop    %ebp
80104b8a:	c3                   	ret    
80104b8b:	90                   	nop
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b95:	eb ee                	jmp    80104b85 <fetchint+0x25>
80104b97:	89 f6                	mov    %esi,%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ba0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	53                   	push   %ebx
80104ba4:	83 ec 04             	sub    $0x4,%esp
80104ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104baa:	e8 e1 ec ff ff       	call   80103890 <myproc>

  if(addr >= curproc->sz)
80104baf:	39 18                	cmp    %ebx,(%eax)
80104bb1:	76 29                	jbe    80104bdc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104bb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104bb6:	89 da                	mov    %ebx,%edx
80104bb8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104bba:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104bbc:	39 c3                	cmp    %eax,%ebx
80104bbe:	73 1c                	jae    80104bdc <fetchstr+0x3c>
    if(*s == 0)
80104bc0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104bc3:	75 10                	jne    80104bd5 <fetchstr+0x35>
80104bc5:	eb 39                	jmp    80104c00 <fetchstr+0x60>
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bd0:	80 3a 00             	cmpb   $0x0,(%edx)
80104bd3:	74 1b                	je     80104bf0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104bd5:	83 c2 01             	add    $0x1,%edx
80104bd8:	39 d0                	cmp    %edx,%eax
80104bda:	77 f4                	ja     80104bd0 <fetchstr+0x30>
    return -1;
80104bdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104be1:	83 c4 04             	add    $0x4,%esp
80104be4:	5b                   	pop    %ebx
80104be5:	5d                   	pop    %ebp
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bf0:	83 c4 04             	add    $0x4,%esp
80104bf3:	89 d0                	mov    %edx,%eax
80104bf5:	29 d8                	sub    %ebx,%eax
80104bf7:	5b                   	pop    %ebx
80104bf8:	5d                   	pop    %ebp
80104bf9:	c3                   	ret    
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c00:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c02:	eb dd                	jmp    80104be1 <fetchstr+0x41>
80104c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
//  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
  return fetchint((mythd()->tf->esp) + 4 + 4*n, ip);
80104c15:	e8 a6 ec ff ff       	call   801038c0 <mythd>
80104c1a:	8b 40 14             	mov    0x14(%eax),%eax
80104c1d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c20:	8b 40 44             	mov    0x44(%eax),%eax
80104c23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c26:	e8 65 ec ff ff       	call   80103890 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c2b:	8b 00                	mov    (%eax),%eax
  return fetchint((mythd()->tf->esp) + 4 + 4*n, ip);
80104c2d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c30:	39 c6                	cmp    %eax,%esi
80104c32:	73 1c                	jae    80104c50 <argint+0x40>
80104c34:	8d 53 08             	lea    0x8(%ebx),%edx
80104c37:	39 d0                	cmp    %edx,%eax
80104c39:	72 15                	jb     80104c50 <argint+0x40>
  *ip = *(int*)(addr);
80104c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c3e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c41:	89 10                	mov    %edx,(%eax)
  return 0;
80104c43:	31 c0                	xor    %eax,%eax
}
80104c45:	5b                   	pop    %ebx
80104c46:	5e                   	pop    %esi
80104c47:	5d                   	pop    %ebp
80104c48:	c3                   	ret    
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((mythd()->tf->esp) + 4 + 4*n, ip);
80104c55:	eb ee                	jmp    80104c45 <argint+0x35>
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
80104c65:	83 ec 10             	sub    $0x10,%esp
80104c68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c6b:	e8 20 ec ff ff       	call   80103890 <myproc>
80104c70:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104c72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c75:	83 ec 08             	sub    $0x8,%esp
80104c78:	50                   	push   %eax
80104c79:	ff 75 08             	pushl  0x8(%ebp)
80104c7c:	e8 8f ff ff ff       	call   80104c10 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c81:	83 c4 10             	add    $0x10,%esp
80104c84:	85 c0                	test   %eax,%eax
80104c86:	78 28                	js     80104cb0 <argptr+0x50>
80104c88:	85 db                	test   %ebx,%ebx
80104c8a:	78 24                	js     80104cb0 <argptr+0x50>
80104c8c:	8b 16                	mov    (%esi),%edx
80104c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c91:	39 c2                	cmp    %eax,%edx
80104c93:	76 1b                	jbe    80104cb0 <argptr+0x50>
80104c95:	01 c3                	add    %eax,%ebx
80104c97:	39 da                	cmp    %ebx,%edx
80104c99:	72 15                	jb     80104cb0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c9e:	89 02                	mov    %eax,(%edx)
  return 0;
80104ca0:	31 c0                	xor    %eax,%eax
}
80104ca2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cb5:	eb eb                	jmp    80104ca2 <argptr+0x42>
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104cc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cc9:	50                   	push   %eax
80104cca:	ff 75 08             	pushl  0x8(%ebp)
80104ccd:	e8 3e ff ff ff       	call   80104c10 <argint>
80104cd2:	83 c4 10             	add    $0x10,%esp
80104cd5:	85 c0                	test   %eax,%eax
80104cd7:	78 17                	js     80104cf0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104cd9:	83 ec 08             	sub    $0x8,%esp
80104cdc:	ff 75 0c             	pushl  0xc(%ebp)
80104cdf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ce2:	e8 b9 fe ff ff       	call   80104ba0 <fetchstr>
80104ce7:	83 c4 10             	add    $0x10,%esp
}
80104cea:	c9                   	leave  
80104ceb:	c3                   	ret    
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cf5:	c9                   	leave  
80104cf6:	c3                   	ret    
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <syscall>:
    curproc->tf->eax = -1;
  }
}*/
void
syscall(void)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
80104d05:	53                   	push   %ebx
80104d06:	83 ec 0c             	sub    $0xc,%esp
  int num;
  struct thread *curthd = mythd();
80104d09:	e8 b2 eb ff ff       	call   801038c0 <mythd>
80104d0e:	89 c6                	mov    %eax,%esi

  num = curthd->tf->eax;
80104d10:	8b 40 14             	mov    0x14(%eax),%eax
80104d13:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d16:	8d 43 ff             	lea    -0x1(%ebx),%eax
80104d19:	83 f8 22             	cmp    $0x22,%eax
80104d1c:	77 22                	ja     80104d40 <syscall+0x40>
80104d1e:	8b 04 9d e0 8a 10 80 	mov    -0x7fef7520(,%ebx,4),%eax
80104d25:	85 c0                	test   %eax,%eax
80104d27:	74 17                	je     80104d40 <syscall+0x40>
    curthd->tf->eax = syscalls[num]();
80104d29:	ff d0                	call   *%eax
80104d2b:	8b 56 14             	mov    0x14(%esi),%edx
80104d2e:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            myproc()->pid, myproc()->name, num);
    curthd->tf->eax = -1;
  }
}
80104d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d34:	5b                   	pop    %ebx
80104d35:	5e                   	pop    %esi
80104d36:	5f                   	pop    %edi
80104d37:	5d                   	pop    %ebp
80104d38:	c3                   	ret    
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            myproc()->pid, myproc()->name, num);
80104d40:	e8 4b eb ff ff       	call   80103890 <myproc>
80104d45:	89 c7                	mov    %eax,%edi
80104d47:	83 c7 60             	add    $0x60,%edi
80104d4a:	e8 41 eb ff ff       	call   80103890 <myproc>
    cprintf("%d %s: unknown sys call %d\n",
80104d4f:	53                   	push   %ebx
80104d50:	57                   	push   %edi
80104d51:	ff 70 0c             	pushl  0xc(%eax)
80104d54:	68 bd 8a 10 80       	push   $0x80108abd
80104d59:	e8 f2 b8 ff ff       	call   80100650 <cprintf>
    curthd->tf->eax = -1;
80104d5e:	8b 46 14             	mov    0x14(%esi),%eax
80104d61:	83 c4 10             	add    $0x10,%esp
80104d64:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d6e:	5b                   	pop    %ebx
80104d6f:	5e                   	pop    %esi
80104d70:	5f                   	pop    %edi
80104d71:	5d                   	pop    %ebp
80104d72:	c3                   	ret    
80104d73:	66 90                	xchg   %ax,%ax
80104d75:	66 90                	xchg   %ax,%ax
80104d77:	66 90                	xchg   %ax,%ax
80104d79:	66 90                	xchg   %ax,%ax
80104d7b:	66 90                	xchg   %ax,%ax
80104d7d:	66 90                	xchg   %ax,%ax
80104d7f:	90                   	nop

80104d80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
80104d85:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d86:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104d89:	83 ec 34             	sub    $0x34,%esp
80104d8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d92:	56                   	push   %esi
80104d93:	50                   	push   %eax
{
80104d94:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d9a:	e8 41 d2 ff ff       	call   80101fe0 <nameiparent>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	0f 84 46 01 00 00    	je     80104ef0 <create+0x170>
    return 0;
  ilock(dp);
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	89 c3                	mov    %eax,%ebx
80104daf:	50                   	push   %eax
80104db0:	e8 ab c9 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104db5:	83 c4 0c             	add    $0xc,%esp
80104db8:	6a 00                	push   $0x0
80104dba:	56                   	push   %esi
80104dbb:	53                   	push   %ebx
80104dbc:	e8 cf ce ff ff       	call   80101c90 <dirlookup>
80104dc1:	83 c4 10             	add    $0x10,%esp
80104dc4:	85 c0                	test   %eax,%eax
80104dc6:	89 c7                	mov    %eax,%edi
80104dc8:	74 36                	je     80104e00 <create+0x80>
    iunlockput(dp);
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	53                   	push   %ebx
80104dce:	e8 1d cc ff ff       	call   801019f0 <iunlockput>
    ilock(ip);
80104dd3:	89 3c 24             	mov    %edi,(%esp)
80104dd6:	e8 85 c9 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ddb:	83 c4 10             	add    $0x10,%esp
80104dde:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104de3:	0f 85 97 00 00 00    	jne    80104e80 <create+0x100>
80104de9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104dee:	0f 85 8c 00 00 00    	jne    80104e80 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104df7:	89 f8                	mov    %edi,%eax
80104df9:	5b                   	pop    %ebx
80104dfa:	5e                   	pop    %esi
80104dfb:	5f                   	pop    %edi
80104dfc:	5d                   	pop    %ebp
80104dfd:	c3                   	ret    
80104dfe:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104e00:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e04:	83 ec 08             	sub    $0x8,%esp
80104e07:	50                   	push   %eax
80104e08:	ff 33                	pushl  (%ebx)
80104e0a:	e8 e1 c7 ff ff       	call   801015f0 <ialloc>
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	85 c0                	test   %eax,%eax
80104e14:	89 c7                	mov    %eax,%edi
80104e16:	0f 84 e8 00 00 00    	je     80104f04 <create+0x184>
  ilock(ip);
80104e1c:	83 ec 0c             	sub    $0xc,%esp
80104e1f:	50                   	push   %eax
80104e20:	e8 3b c9 ff ff       	call   80101760 <ilock>
  ip->major = major;
80104e25:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e29:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104e2d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e31:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104e35:	b8 01 00 00 00       	mov    $0x1,%eax
80104e3a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104e3e:	89 3c 24             	mov    %edi,(%esp)
80104e41:	e8 6a c8 ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e46:	83 c4 10             	add    $0x10,%esp
80104e49:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e4e:	74 50                	je     80104ea0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e50:	83 ec 04             	sub    $0x4,%esp
80104e53:	ff 77 04             	pushl  0x4(%edi)
80104e56:	56                   	push   %esi
80104e57:	53                   	push   %ebx
80104e58:	e8 a3 d0 ff ff       	call   80101f00 <dirlink>
80104e5d:	83 c4 10             	add    $0x10,%esp
80104e60:	85 c0                	test   %eax,%eax
80104e62:	0f 88 8f 00 00 00    	js     80104ef7 <create+0x177>
  iunlockput(dp);
80104e68:	83 ec 0c             	sub    $0xc,%esp
80104e6b:	53                   	push   %ebx
80104e6c:	e8 7f cb ff ff       	call   801019f0 <iunlockput>
  return ip;
80104e71:	83 c4 10             	add    $0x10,%esp
}
80104e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e77:	89 f8                	mov    %edi,%eax
80104e79:	5b                   	pop    %ebx
80104e7a:	5e                   	pop    %esi
80104e7b:	5f                   	pop    %edi
80104e7c:	5d                   	pop    %ebp
80104e7d:	c3                   	ret    
80104e7e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104e80:	83 ec 0c             	sub    $0xc,%esp
80104e83:	57                   	push   %edi
    return 0;
80104e84:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104e86:	e8 65 cb ff ff       	call   801019f0 <iunlockput>
    return 0;
80104e8b:	83 c4 10             	add    $0x10,%esp
}
80104e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e91:	89 f8                	mov    %edi,%eax
80104e93:	5b                   	pop    %ebx
80104e94:	5e                   	pop    %esi
80104e95:	5f                   	pop    %edi
80104e96:	5d                   	pop    %ebp
80104e97:	c3                   	ret    
80104e98:	90                   	nop
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104ea0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ea5:	83 ec 0c             	sub    $0xc,%esp
80104ea8:	53                   	push   %ebx
80104ea9:	e8 02 c8 ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eae:	83 c4 0c             	add    $0xc,%esp
80104eb1:	ff 77 04             	pushl  0x4(%edi)
80104eb4:	68 8c 8b 10 80       	push   $0x80108b8c
80104eb9:	57                   	push   %edi
80104eba:	e8 41 d0 ff ff       	call   80101f00 <dirlink>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	78 1c                	js     80104ee2 <create+0x162>
80104ec6:	83 ec 04             	sub    $0x4,%esp
80104ec9:	ff 73 04             	pushl  0x4(%ebx)
80104ecc:	68 8b 8b 10 80       	push   $0x80108b8b
80104ed1:	57                   	push   %edi
80104ed2:	e8 29 d0 ff ff       	call   80101f00 <dirlink>
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	85 c0                	test   %eax,%eax
80104edc:	0f 89 6e ff ff ff    	jns    80104e50 <create+0xd0>
      panic("create dots");
80104ee2:	83 ec 0c             	sub    $0xc,%esp
80104ee5:	68 7f 8b 10 80       	push   $0x80108b7f
80104eea:	e8 91 b4 ff ff       	call   80100380 <panic>
80104eef:	90                   	nop
    return 0;
80104ef0:	31 ff                	xor    %edi,%edi
80104ef2:	e9 fd fe ff ff       	jmp    80104df4 <create+0x74>
    panic("create: dirlink");
80104ef7:	83 ec 0c             	sub    $0xc,%esp
80104efa:	68 8e 8b 10 80       	push   $0x80108b8e
80104eff:	e8 7c b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f04:	83 ec 0c             	sub    $0xc,%esp
80104f07:	68 70 8b 10 80       	push   $0x80108b70
80104f0c:	e8 6f b4 ff ff       	call   80100380 <panic>
80104f11:	eb 0d                	jmp    80104f20 <argfd.constprop.0>
80104f13:	90                   	nop
80104f14:	90                   	nop
80104f15:	90                   	nop
80104f16:	90                   	nop
80104f17:	90                   	nop
80104f18:	90                   	nop
80104f19:	90                   	nop
80104f1a:	90                   	nop
80104f1b:	90                   	nop
80104f1c:	90                   	nop
80104f1d:	90                   	nop
80104f1e:	90                   	nop
80104f1f:	90                   	nop

80104f20 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
80104f25:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104f27:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f2a:	89 d6                	mov    %edx,%esi
80104f2c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2f:	50                   	push   %eax
80104f30:	6a 00                	push   $0x0
80104f32:	e8 d9 fc ff ff       	call   80104c10 <argint>
80104f37:	83 c4 10             	add    $0x10,%esp
80104f3a:	85 c0                	test   %eax,%eax
80104f3c:	78 2a                	js     80104f68 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f42:	77 24                	ja     80104f68 <argfd.constprop.0+0x48>
80104f44:	e8 47 e9 ff ff       	call   80103890 <myproc>
80104f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f4c:	8b 44 90 1c          	mov    0x1c(%eax,%edx,4),%eax
80104f50:	85 c0                	test   %eax,%eax
80104f52:	74 14                	je     80104f68 <argfd.constprop.0+0x48>
  if(pfd)
80104f54:	85 db                	test   %ebx,%ebx
80104f56:	74 02                	je     80104f5a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f58:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104f5a:	89 06                	mov    %eax,(%esi)
  return 0;
80104f5c:	31 c0                	xor    %eax,%eax
}
80104f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f61:	5b                   	pop    %ebx
80104f62:	5e                   	pop    %esi
80104f63:	5d                   	pop    %ebp
80104f64:	c3                   	ret    
80104f65:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6d:	eb ef                	jmp    80104f5e <argfd.constprop.0+0x3e>
80104f6f:	90                   	nop

80104f70 <sys_dup>:
{
80104f70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104f71:	31 c0                	xor    %eax,%eax
{
80104f73:	89 e5                	mov    %esp,%ebp
80104f75:	56                   	push   %esi
80104f76:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104f77:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104f7a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104f7d:	e8 9e ff ff ff       	call   80104f20 <argfd.constprop.0>
80104f82:	85 c0                	test   %eax,%eax
80104f84:	78 42                	js     80104fc8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104f86:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f89:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104f8b:	e8 00 e9 ff ff       	call   80103890 <myproc>
80104f90:	eb 0e                	jmp    80104fa0 <sys_dup+0x30>
80104f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f98:	83 c3 01             	add    $0x1,%ebx
80104f9b:	83 fb 10             	cmp    $0x10,%ebx
80104f9e:	74 28                	je     80104fc8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104fa0:	8b 54 98 1c          	mov    0x1c(%eax,%ebx,4),%edx
80104fa4:	85 d2                	test   %edx,%edx
80104fa6:	75 f0                	jne    80104f98 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104fa8:	89 74 98 1c          	mov    %esi,0x1c(%eax,%ebx,4)
  filedup(f);
80104fac:	83 ec 0c             	sub    $0xc,%esp
80104faf:	ff 75 f4             	pushl  -0xc(%ebp)
80104fb2:	e8 19 bf ff ff       	call   80100ed0 <filedup>
  return fd;
80104fb7:	83 c4 10             	add    $0x10,%esp
}
80104fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fbd:	89 d8                	mov    %ebx,%eax
80104fbf:	5b                   	pop    %ebx
80104fc0:	5e                   	pop    %esi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	90                   	nop
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fcb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fd0:	89 d8                	mov    %ebx,%eax
80104fd2:	5b                   	pop    %ebx
80104fd3:	5e                   	pop    %esi
80104fd4:	5d                   	pop    %ebp
80104fd5:	c3                   	ret    
80104fd6:	8d 76 00             	lea    0x0(%esi),%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fe0 <sys_read>:
{
80104fe0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fe1:	31 c0                	xor    %eax,%eax
{
80104fe3:	89 e5                	mov    %esp,%ebp
80104fe5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fe8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104feb:	e8 30 ff ff ff       	call   80104f20 <argfd.constprop.0>
80104ff0:	85 c0                	test   %eax,%eax
80104ff2:	78 4c                	js     80105040 <sys_read+0x60>
80104ff4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ff7:	83 ec 08             	sub    $0x8,%esp
80104ffa:	50                   	push   %eax
80104ffb:	6a 02                	push   $0x2
80104ffd:	e8 0e fc ff ff       	call   80104c10 <argint>
80105002:	83 c4 10             	add    $0x10,%esp
80105005:	85 c0                	test   %eax,%eax
80105007:	78 37                	js     80105040 <sys_read+0x60>
80105009:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010500c:	83 ec 04             	sub    $0x4,%esp
8010500f:	ff 75 f0             	pushl  -0x10(%ebp)
80105012:	50                   	push   %eax
80105013:	6a 01                	push   $0x1
80105015:	e8 46 fc ff ff       	call   80104c60 <argptr>
8010501a:	83 c4 10             	add    $0x10,%esp
8010501d:	85 c0                	test   %eax,%eax
8010501f:	78 1f                	js     80105040 <sys_read+0x60>
  return fileread(f, p, n);
80105021:	83 ec 04             	sub    $0x4,%esp
80105024:	ff 75 f0             	pushl  -0x10(%ebp)
80105027:	ff 75 f4             	pushl  -0xc(%ebp)
8010502a:	ff 75 ec             	pushl  -0x14(%ebp)
8010502d:	e8 0e c0 ff ff       	call   80101040 <fileread>
80105032:	83 c4 10             	add    $0x10,%esp
}
80105035:	c9                   	leave  
80105036:	c3                   	ret    
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105045:	c9                   	leave  
80105046:	c3                   	ret    
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <sys_write>:
{
80105050:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105051:	31 c0                	xor    %eax,%eax
{
80105053:	89 e5                	mov    %esp,%ebp
80105055:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105058:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010505b:	e8 c0 fe ff ff       	call   80104f20 <argfd.constprop.0>
80105060:	85 c0                	test   %eax,%eax
80105062:	78 4c                	js     801050b0 <sys_write+0x60>
80105064:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105067:	83 ec 08             	sub    $0x8,%esp
8010506a:	50                   	push   %eax
8010506b:	6a 02                	push   $0x2
8010506d:	e8 9e fb ff ff       	call   80104c10 <argint>
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	85 c0                	test   %eax,%eax
80105077:	78 37                	js     801050b0 <sys_write+0x60>
80105079:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010507c:	83 ec 04             	sub    $0x4,%esp
8010507f:	ff 75 f0             	pushl  -0x10(%ebp)
80105082:	50                   	push   %eax
80105083:	6a 01                	push   $0x1
80105085:	e8 d6 fb ff ff       	call   80104c60 <argptr>
8010508a:	83 c4 10             	add    $0x10,%esp
8010508d:	85 c0                	test   %eax,%eax
8010508f:	78 1f                	js     801050b0 <sys_write+0x60>
  return filewrite(f, p, n);
80105091:	83 ec 04             	sub    $0x4,%esp
80105094:	ff 75 f0             	pushl  -0x10(%ebp)
80105097:	ff 75 f4             	pushl  -0xc(%ebp)
8010509a:	ff 75 ec             	pushl  -0x14(%ebp)
8010509d:	e8 2e c0 ff ff       	call   801010d0 <filewrite>
801050a2:	83 c4 10             	add    $0x10,%esp
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050c0 <sys_close>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801050c6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801050c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050cc:	e8 4f fe ff ff       	call   80104f20 <argfd.constprop.0>
801050d1:	85 c0                	test   %eax,%eax
801050d3:	78 2b                	js     80105100 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801050d5:	e8 b6 e7 ff ff       	call   80103890 <myproc>
801050da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801050dd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050e0:	c7 44 90 1c 00 00 00 	movl   $0x0,0x1c(%eax,%edx,4)
801050e7:	00 
  fileclose(f);
801050e8:	ff 75 f4             	pushl  -0xc(%ebp)
801050eb:	e8 30 be ff ff       	call   80100f20 <fileclose>
  return 0;
801050f0:	83 c4 10             	add    $0x10,%esp
801050f3:	31 c0                	xor    %eax,%eax
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <sys_fstat>:
{
80105110:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105111:	31 c0                	xor    %eax,%eax
{
80105113:	89 e5                	mov    %esp,%ebp
80105115:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105118:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010511b:	e8 00 fe ff ff       	call   80104f20 <argfd.constprop.0>
80105120:	85 c0                	test   %eax,%eax
80105122:	78 2c                	js     80105150 <sys_fstat+0x40>
80105124:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105127:	83 ec 04             	sub    $0x4,%esp
8010512a:	6a 14                	push   $0x14
8010512c:	50                   	push   %eax
8010512d:	6a 01                	push   $0x1
8010512f:	e8 2c fb ff ff       	call   80104c60 <argptr>
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	78 15                	js     80105150 <sys_fstat+0x40>
  return filestat(f, st);
8010513b:	83 ec 08             	sub    $0x8,%esp
8010513e:	ff 75 f4             	pushl  -0xc(%ebp)
80105141:	ff 75 f0             	pushl  -0x10(%ebp)
80105144:	e8 a7 be ff ff       	call   80100ff0 <filestat>
80105149:	83 c4 10             	add    $0x10,%esp
}
8010514c:	c9                   	leave  
8010514d:	c3                   	ret    
8010514e:	66 90                	xchg   %ax,%ax
    return -1;
80105150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105155:	c9                   	leave  
80105156:	c3                   	ret    
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <sys_link>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
80105165:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105166:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105169:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 4c fb ff ff       	call   80104cc0 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 fb 00 00 00    	js     8010527a <sys_link+0x11a>
8010517f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105182:	83 ec 08             	sub    $0x8,%esp
80105185:	50                   	push   %eax
80105186:	6a 01                	push   $0x1
80105188:	e8 33 fb ff ff       	call   80104cc0 <argstr>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	0f 88 e2 00 00 00    	js     8010527a <sys_link+0x11a>
  begin_op();
80105198:	e8 e3 da ff ff       	call   80102c80 <begin_op>
  if((ip = namei(old)) == 0){
8010519d:	83 ec 0c             	sub    $0xc,%esp
801051a0:	ff 75 d4             	pushl  -0x2c(%ebp)
801051a3:	e8 18 ce ff ff       	call   80101fc0 <namei>
801051a8:	83 c4 10             	add    $0x10,%esp
801051ab:	85 c0                	test   %eax,%eax
801051ad:	89 c3                	mov    %eax,%ebx
801051af:	0f 84 ea 00 00 00    	je     8010529f <sys_link+0x13f>
  ilock(ip);
801051b5:	83 ec 0c             	sub    $0xc,%esp
801051b8:	50                   	push   %eax
801051b9:	e8 a2 c5 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
801051be:	83 c4 10             	add    $0x10,%esp
801051c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051c6:	0f 84 bb 00 00 00    	je     80105287 <sys_link+0x127>
  ip->nlink++;
801051cc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801051d1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801051d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051d7:	53                   	push   %ebx
801051d8:	e8 d3 c4 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
801051dd:	89 1c 24             	mov    %ebx,(%esp)
801051e0:	e8 5b c6 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051e5:	58                   	pop    %eax
801051e6:	5a                   	pop    %edx
801051e7:	57                   	push   %edi
801051e8:	ff 75 d0             	pushl  -0x30(%ebp)
801051eb:	e8 f0 cd ff ff       	call   80101fe0 <nameiparent>
801051f0:	83 c4 10             	add    $0x10,%esp
801051f3:	85 c0                	test   %eax,%eax
801051f5:	89 c6                	mov    %eax,%esi
801051f7:	74 5b                	je     80105254 <sys_link+0xf4>
  ilock(dp);
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	50                   	push   %eax
801051fd:	e8 5e c5 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	8b 03                	mov    (%ebx),%eax
80105207:	39 06                	cmp    %eax,(%esi)
80105209:	75 3d                	jne    80105248 <sys_link+0xe8>
8010520b:	83 ec 04             	sub    $0x4,%esp
8010520e:	ff 73 04             	pushl  0x4(%ebx)
80105211:	57                   	push   %edi
80105212:	56                   	push   %esi
80105213:	e8 e8 cc ff ff       	call   80101f00 <dirlink>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	85 c0                	test   %eax,%eax
8010521d:	78 29                	js     80105248 <sys_link+0xe8>
  iunlockput(dp);
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	56                   	push   %esi
80105223:	e8 c8 c7 ff ff       	call   801019f0 <iunlockput>
  iput(ip);
80105228:	89 1c 24             	mov    %ebx,(%esp)
8010522b:	e8 60 c6 ff ff       	call   80101890 <iput>
  end_op();
80105230:	e8 bb da ff ff       	call   80102cf0 <end_op>
  return 0;
80105235:	83 c4 10             	add    $0x10,%esp
80105238:	31 c0                	xor    %eax,%eax
}
8010523a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010523d:	5b                   	pop    %ebx
8010523e:	5e                   	pop    %esi
8010523f:	5f                   	pop    %edi
80105240:	5d                   	pop    %ebp
80105241:	c3                   	ret    
80105242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105248:	83 ec 0c             	sub    $0xc,%esp
8010524b:	56                   	push   %esi
8010524c:	e8 9f c7 ff ff       	call   801019f0 <iunlockput>
    goto bad;
80105251:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	53                   	push   %ebx
80105258:	e8 03 c5 ff ff       	call   80101760 <ilock>
  ip->nlink--;
8010525d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105262:	89 1c 24             	mov    %ebx,(%esp)
80105265:	e8 46 c4 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
8010526a:	89 1c 24             	mov    %ebx,(%esp)
8010526d:	e8 7e c7 ff ff       	call   801019f0 <iunlockput>
  end_op();
80105272:	e8 79 da ff ff       	call   80102cf0 <end_op>
  return -1;
80105277:	83 c4 10             	add    $0x10,%esp
}
8010527a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010527d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105282:	5b                   	pop    %ebx
80105283:	5e                   	pop    %esi
80105284:	5f                   	pop    %edi
80105285:	5d                   	pop    %ebp
80105286:	c3                   	ret    
    iunlockput(ip);
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	53                   	push   %ebx
8010528b:	e8 60 c7 ff ff       	call   801019f0 <iunlockput>
    end_op();
80105290:	e8 5b da ff ff       	call   80102cf0 <end_op>
    return -1;
80105295:	83 c4 10             	add    $0x10,%esp
80105298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010529d:	eb 9b                	jmp    8010523a <sys_link+0xda>
    end_op();
8010529f:	e8 4c da ff ff       	call   80102cf0 <end_op>
    return -1;
801052a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a9:	eb 8f                	jmp    8010523a <sys_link+0xda>
801052ab:	90                   	nop
801052ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052b0 <sys_unlink>:
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801052b6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052b9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801052bc:	50                   	push   %eax
801052bd:	6a 00                	push   $0x0
801052bf:	e8 fc f9 ff ff       	call   80104cc0 <argstr>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	0f 88 77 01 00 00    	js     80105446 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801052cf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801052d2:	e8 a9 d9 ff ff       	call   80102c80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052d7:	83 ec 08             	sub    $0x8,%esp
801052da:	53                   	push   %ebx
801052db:	ff 75 c0             	pushl  -0x40(%ebp)
801052de:	e8 fd cc ff ff       	call   80101fe0 <nameiparent>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	89 c6                	mov    %eax,%esi
801052ea:	0f 84 60 01 00 00    	je     80105450 <sys_unlink+0x1a0>
  ilock(dp);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	50                   	push   %eax
801052f4:	e8 67 c4 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052f9:	58                   	pop    %eax
801052fa:	5a                   	pop    %edx
801052fb:	68 8c 8b 10 80       	push   $0x80108b8c
80105300:	53                   	push   %ebx
80105301:	e8 6a c9 ff ff       	call   80101c70 <namecmp>
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	85 c0                	test   %eax,%eax
8010530b:	0f 84 03 01 00 00    	je     80105414 <sys_unlink+0x164>
80105311:	83 ec 08             	sub    $0x8,%esp
80105314:	68 8b 8b 10 80       	push   $0x80108b8b
80105319:	53                   	push   %ebx
8010531a:	e8 51 c9 ff ff       	call   80101c70 <namecmp>
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	85 c0                	test   %eax,%eax
80105324:	0f 84 ea 00 00 00    	je     80105414 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010532a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010532d:	83 ec 04             	sub    $0x4,%esp
80105330:	50                   	push   %eax
80105331:	53                   	push   %ebx
80105332:	56                   	push   %esi
80105333:	e8 58 c9 ff ff       	call   80101c90 <dirlookup>
80105338:	83 c4 10             	add    $0x10,%esp
8010533b:	85 c0                	test   %eax,%eax
8010533d:	89 c3                	mov    %eax,%ebx
8010533f:	0f 84 cf 00 00 00    	je     80105414 <sys_unlink+0x164>
  ilock(ip);
80105345:	83 ec 0c             	sub    $0xc,%esp
80105348:	50                   	push   %eax
80105349:	e8 12 c4 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105356:	0f 8e 10 01 00 00    	jle    8010546c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010535c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105361:	74 6d                	je     801053d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105363:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105366:	83 ec 04             	sub    $0x4,%esp
80105369:	6a 10                	push   $0x10
8010536b:	6a 00                	push   $0x0
8010536d:	50                   	push   %eax
8010536e:	e8 9d f5 ff ff       	call   80104910 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105373:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105376:	6a 10                	push   $0x10
80105378:	ff 75 c4             	pushl  -0x3c(%ebp)
8010537b:	50                   	push   %eax
8010537c:	56                   	push   %esi
8010537d:	e8 be c7 ff ff       	call   80101b40 <writei>
80105382:	83 c4 20             	add    $0x20,%esp
80105385:	83 f8 10             	cmp    $0x10,%eax
80105388:	0f 85 eb 00 00 00    	jne    80105479 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010538e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105393:	0f 84 97 00 00 00    	je     80105430 <sys_unlink+0x180>
  iunlockput(dp);
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	56                   	push   %esi
8010539d:	e8 4e c6 ff ff       	call   801019f0 <iunlockput>
  ip->nlink--;
801053a2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053a7:	89 1c 24             	mov    %ebx,(%esp)
801053aa:	e8 01 c3 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
801053af:	89 1c 24             	mov    %ebx,(%esp)
801053b2:	e8 39 c6 ff ff       	call   801019f0 <iunlockput>
  end_op();
801053b7:	e8 34 d9 ff ff       	call   80102cf0 <end_op>
  return 0;
801053bc:	83 c4 10             	add    $0x10,%esp
801053bf:	31 c0                	xor    %eax,%eax
}
801053c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c4:	5b                   	pop    %ebx
801053c5:	5e                   	pop    %esi
801053c6:	5f                   	pop    %edi
801053c7:	5d                   	pop    %ebp
801053c8:	c3                   	ret    
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053d4:	76 8d                	jbe    80105363 <sys_unlink+0xb3>
801053d6:	bf 20 00 00 00       	mov    $0x20,%edi
801053db:	eb 0f                	jmp    801053ec <sys_unlink+0x13c>
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
801053e0:	83 c7 10             	add    $0x10,%edi
801053e3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801053e6:	0f 83 77 ff ff ff    	jae    80105363 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053ef:	6a 10                	push   $0x10
801053f1:	57                   	push   %edi
801053f2:	50                   	push   %eax
801053f3:	53                   	push   %ebx
801053f4:	e8 47 c6 ff ff       	call   80101a40 <readi>
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	83 f8 10             	cmp    $0x10,%eax
801053ff:	75 5e                	jne    8010545f <sys_unlink+0x1af>
    if(de.inum != 0)
80105401:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105406:	74 d8                	je     801053e0 <sys_unlink+0x130>
    iunlockput(ip);
80105408:	83 ec 0c             	sub    $0xc,%esp
8010540b:	53                   	push   %ebx
8010540c:	e8 df c5 ff ff       	call   801019f0 <iunlockput>
    goto bad;
80105411:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	56                   	push   %esi
80105418:	e8 d3 c5 ff ff       	call   801019f0 <iunlockput>
  end_op();
8010541d:	e8 ce d8 ff ff       	call   80102cf0 <end_op>
  return -1;
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542a:	eb 95                	jmp    801053c1 <sys_unlink+0x111>
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105430:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105435:	83 ec 0c             	sub    $0xc,%esp
80105438:	56                   	push   %esi
80105439:	e8 72 c2 ff ff       	call   801016b0 <iupdate>
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	e9 53 ff ff ff       	jmp    80105399 <sys_unlink+0xe9>
    return -1;
80105446:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544b:	e9 71 ff ff ff       	jmp    801053c1 <sys_unlink+0x111>
    end_op();
80105450:	e8 9b d8 ff ff       	call   80102cf0 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545a:	e9 62 ff ff ff       	jmp    801053c1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010545f:	83 ec 0c             	sub    $0xc,%esp
80105462:	68 b0 8b 10 80       	push   $0x80108bb0
80105467:	e8 14 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010546c:	83 ec 0c             	sub    $0xc,%esp
8010546f:	68 9e 8b 10 80       	push   $0x80108b9e
80105474:	e8 07 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105479:	83 ec 0c             	sub    $0xc,%esp
8010547c:	68 c2 8b 10 80       	push   $0x80108bc2
80105481:	e8 fa ae ff ff       	call   80100380 <panic>
80105486:	8d 76 00             	lea    0x0(%esi),%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_open>:

int
sys_open(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
80105495:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105496:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105499:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010549c:	50                   	push   %eax
8010549d:	6a 00                	push   $0x0
8010549f:	e8 1c f8 ff ff       	call   80104cc0 <argstr>
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	85 c0                	test   %eax,%eax
801054a9:	0f 88 1d 01 00 00    	js     801055cc <sys_open+0x13c>
801054af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054b2:	83 ec 08             	sub    $0x8,%esp
801054b5:	50                   	push   %eax
801054b6:	6a 01                	push   $0x1
801054b8:	e8 53 f7 ff ff       	call   80104c10 <argint>
801054bd:	83 c4 10             	add    $0x10,%esp
801054c0:	85 c0                	test   %eax,%eax
801054c2:	0f 88 04 01 00 00    	js     801055cc <sys_open+0x13c>
    return -1;

  begin_op();
801054c8:	e8 b3 d7 ff ff       	call   80102c80 <begin_op>

  if(omode & O_CREATE){
801054cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054d1:	0f 85 a9 00 00 00    	jne    80105580 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054d7:	83 ec 0c             	sub    $0xc,%esp
801054da:	ff 75 e0             	pushl  -0x20(%ebp)
801054dd:	e8 de ca ff ff       	call   80101fc0 <namei>
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	85 c0                	test   %eax,%eax
801054e7:	89 c6                	mov    %eax,%esi
801054e9:	0f 84 b2 00 00 00    	je     801055a1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801054ef:	83 ec 0c             	sub    $0xc,%esp
801054f2:	50                   	push   %eax
801054f3:	e8 68 c2 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054f8:	83 c4 10             	add    $0x10,%esp
801054fb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105500:	0f 84 aa 00 00 00    	je     801055b0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105506:	e8 55 b9 ff ff       	call   80100e60 <filealloc>
8010550b:	85 c0                	test   %eax,%eax
8010550d:	89 c7                	mov    %eax,%edi
8010550f:	0f 84 a6 00 00 00    	je     801055bb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105515:	e8 76 e3 ff ff       	call   80103890 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010551a:	31 db                	xor    %ebx,%ebx
8010551c:	eb 0e                	jmp    8010552c <sys_open+0x9c>
8010551e:	66 90                	xchg   %ax,%ax
80105520:	83 c3 01             	add    $0x1,%ebx
80105523:	83 fb 10             	cmp    $0x10,%ebx
80105526:	0f 84 ac 00 00 00    	je     801055d8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010552c:	8b 54 98 1c          	mov    0x1c(%eax,%ebx,4),%edx
80105530:	85 d2                	test   %edx,%edx
80105532:	75 ec                	jne    80105520 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105534:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105537:	89 7c 98 1c          	mov    %edi,0x1c(%eax,%ebx,4)
  iunlock(ip);
8010553b:	56                   	push   %esi
8010553c:	e8 ff c2 ff ff       	call   80101840 <iunlock>
  end_op();
80105541:	e8 aa d7 ff ff       	call   80102cf0 <end_op>

  f->type = FD_INODE;
80105546:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010554c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010554f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105552:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105555:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010555c:	89 d0                	mov    %edx,%eax
8010555e:	f7 d0                	not    %eax
80105560:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105563:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105566:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105569:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010556d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105570:	89 d8                	mov    %ebx,%eax
80105572:	5b                   	pop    %ebx
80105573:	5e                   	pop    %esi
80105574:	5f                   	pop    %edi
80105575:	5d                   	pop    %ebp
80105576:	c3                   	ret    
80105577:	89 f6                	mov    %esi,%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105586:	31 c9                	xor    %ecx,%ecx
80105588:	6a 00                	push   $0x0
8010558a:	ba 02 00 00 00       	mov    $0x2,%edx
8010558f:	e8 ec f7 ff ff       	call   80104d80 <create>
    if(ip == 0){
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105599:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010559b:	0f 85 65 ff ff ff    	jne    80105506 <sys_open+0x76>
      end_op();
801055a1:	e8 4a d7 ff ff       	call   80102cf0 <end_op>
      return -1;
801055a6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055ab:	eb c0                	jmp    8010556d <sys_open+0xdd>
801055ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801055b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055b3:	85 c9                	test   %ecx,%ecx
801055b5:	0f 84 4b ff ff ff    	je     80105506 <sys_open+0x76>
    iunlockput(ip);
801055bb:	83 ec 0c             	sub    $0xc,%esp
801055be:	56                   	push   %esi
801055bf:	e8 2c c4 ff ff       	call   801019f0 <iunlockput>
    end_op();
801055c4:	e8 27 d7 ff ff       	call   80102cf0 <end_op>
    return -1;
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055d1:	eb 9a                	jmp    8010556d <sys_open+0xdd>
801055d3:	90                   	nop
801055d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	57                   	push   %edi
801055dc:	e8 3f b9 ff ff       	call   80100f20 <fileclose>
801055e1:	83 c4 10             	add    $0x10,%esp
801055e4:	eb d5                	jmp    801055bb <sys_open+0x12b>
801055e6:	8d 76 00             	lea    0x0(%esi),%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055f6:	e8 85 d6 ff ff       	call   80102c80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055fe:	83 ec 08             	sub    $0x8,%esp
80105601:	50                   	push   %eax
80105602:	6a 00                	push   $0x0
80105604:	e8 b7 f6 ff ff       	call   80104cc0 <argstr>
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	85 c0                	test   %eax,%eax
8010560e:	78 30                	js     80105640 <sys_mkdir+0x50>
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105616:	31 c9                	xor    %ecx,%ecx
80105618:	6a 00                	push   $0x0
8010561a:	ba 01 00 00 00       	mov    $0x1,%edx
8010561f:	e8 5c f7 ff ff       	call   80104d80 <create>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	74 15                	je     80105640 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010562b:	83 ec 0c             	sub    $0xc,%esp
8010562e:	50                   	push   %eax
8010562f:	e8 bc c3 ff ff       	call   801019f0 <iunlockput>
  end_op();
80105634:	e8 b7 d6 ff ff       	call   80102cf0 <end_op>
  return 0;
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	31 c0                	xor    %eax,%eax
}
8010563e:	c9                   	leave  
8010563f:	c3                   	ret    
    end_op();
80105640:	e8 ab d6 ff ff       	call   80102cf0 <end_op>
    return -1;
80105645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_mknod>:

int
sys_mknod(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105656:	e8 25 d6 ff ff       	call   80102c80 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010565b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010565e:	83 ec 08             	sub    $0x8,%esp
80105661:	50                   	push   %eax
80105662:	6a 00                	push   $0x0
80105664:	e8 57 f6 ff ff       	call   80104cc0 <argstr>
80105669:	83 c4 10             	add    $0x10,%esp
8010566c:	85 c0                	test   %eax,%eax
8010566e:	78 60                	js     801056d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105670:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105673:	83 ec 08             	sub    $0x8,%esp
80105676:	50                   	push   %eax
80105677:	6a 01                	push   $0x1
80105679:	e8 92 f5 ff ff       	call   80104c10 <argint>
  if((argstr(0, &path)) < 0 ||
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	85 c0                	test   %eax,%eax
80105683:	78 4b                	js     801056d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105685:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105688:	83 ec 08             	sub    $0x8,%esp
8010568b:	50                   	push   %eax
8010568c:	6a 02                	push   $0x2
8010568e:	e8 7d f5 ff ff       	call   80104c10 <argint>
     argint(1, &major) < 0 ||
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 c0                	test   %eax,%eax
80105698:	78 36                	js     801056d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010569a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010569e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801056a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801056a5:	ba 03 00 00 00       	mov    $0x3,%edx
801056aa:	50                   	push   %eax
801056ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056ae:	e8 cd f6 ff ff       	call   80104d80 <create>
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 c0                	test   %eax,%eax
801056b8:	74 16                	je     801056d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ba:	83 ec 0c             	sub    $0xc,%esp
801056bd:	50                   	push   %eax
801056be:	e8 2d c3 ff ff       	call   801019f0 <iunlockput>
  end_op();
801056c3:	e8 28 d6 ff ff       	call   80102cf0 <end_op>
  return 0;
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	31 c0                	xor    %eax,%eax
}
801056cd:	c9                   	leave  
801056ce:	c3                   	ret    
801056cf:	90                   	nop
    end_op();
801056d0:	e8 1b d6 ff ff       	call   80102cf0 <end_op>
    return -1;
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056da:	c9                   	leave  
801056db:	c3                   	ret    
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_chdir>:

int
sys_chdir(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	56                   	push   %esi
801056e4:	53                   	push   %ebx
801056e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056e8:	e8 a3 e1 ff ff       	call   80103890 <myproc>
801056ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056ef:	e8 8c d5 ff ff       	call   80102c80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f7:	83 ec 08             	sub    $0x8,%esp
801056fa:	50                   	push   %eax
801056fb:	6a 00                	push   $0x0
801056fd:	e8 be f5 ff ff       	call   80104cc0 <argstr>
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	85 c0                	test   %eax,%eax
80105707:	78 77                	js     80105780 <sys_chdir+0xa0>
80105709:	83 ec 0c             	sub    $0xc,%esp
8010570c:	ff 75 f4             	pushl  -0xc(%ebp)
8010570f:	e8 ac c8 ff ff       	call   80101fc0 <namei>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	89 c3                	mov    %eax,%ebx
8010571b:	74 63                	je     80105780 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010571d:	83 ec 0c             	sub    $0xc,%esp
80105720:	50                   	push   %eax
80105721:	e8 3a c0 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010572e:	75 30                	jne    80105760 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	53                   	push   %ebx
80105734:	e8 07 c1 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105739:	58                   	pop    %eax
8010573a:	ff 76 5c             	pushl  0x5c(%esi)
8010573d:	e8 4e c1 ff ff       	call   80101890 <iput>
  end_op();
80105742:	e8 a9 d5 ff ff       	call   80102cf0 <end_op>
  curproc->cwd = ip;
80105747:	89 5e 5c             	mov    %ebx,0x5c(%esi)
  return 0;
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	31 c0                	xor    %eax,%eax
}
8010574f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105752:	5b                   	pop    %ebx
80105753:	5e                   	pop    %esi
80105754:	5d                   	pop    %ebp
80105755:	c3                   	ret    
80105756:	8d 76 00             	lea    0x0(%esi),%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	53                   	push   %ebx
80105764:	e8 87 c2 ff ff       	call   801019f0 <iunlockput>
    end_op();
80105769:	e8 82 d5 ff ff       	call   80102cf0 <end_op>
    return -1;
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105776:	eb d7                	jmp    8010574f <sys_chdir+0x6f>
80105778:	90                   	nop
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105780:	e8 6b d5 ff ff       	call   80102cf0 <end_op>
    return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010578a:	eb c3                	jmp    8010574f <sys_chdir+0x6f>
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_exec>:

int
sys_exec(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
80105795:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105796:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010579c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057a2:	50                   	push   %eax
801057a3:	6a 00                	push   $0x0
801057a5:	e8 16 f5 ff ff       	call   80104cc0 <argstr>
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	85 c0                	test   %eax,%eax
801057af:	0f 88 87 00 00 00    	js     8010583c <sys_exec+0xac>
801057b5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057bb:	83 ec 08             	sub    $0x8,%esp
801057be:	50                   	push   %eax
801057bf:	6a 01                	push   $0x1
801057c1:	e8 4a f4 ff ff       	call   80104c10 <argint>
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	85 c0                	test   %eax,%eax
801057cb:	78 6f                	js     8010583c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057cd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801057d3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801057d6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057d8:	68 80 00 00 00       	push   $0x80
801057dd:	6a 00                	push   $0x0
801057df:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801057e5:	50                   	push   %eax
801057e6:	e8 25 f1 ff ff       	call   80104910 <memset>
801057eb:	83 c4 10             	add    $0x10,%esp
801057ee:	eb 2c                	jmp    8010581c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801057f0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057f6:	85 c0                	test   %eax,%eax
801057f8:	74 56                	je     80105850 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057fa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105800:	83 ec 08             	sub    $0x8,%esp
80105803:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105806:	52                   	push   %edx
80105807:	50                   	push   %eax
80105808:	e8 93 f3 ff ff       	call   80104ba0 <fetchstr>
8010580d:	83 c4 10             	add    $0x10,%esp
80105810:	85 c0                	test   %eax,%eax
80105812:	78 28                	js     8010583c <sys_exec+0xac>
  for(i=0;; i++){
80105814:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105817:	83 fb 20             	cmp    $0x20,%ebx
8010581a:	74 20                	je     8010583c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010581c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105822:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105829:	83 ec 08             	sub    $0x8,%esp
8010582c:	57                   	push   %edi
8010582d:	01 f0                	add    %esi,%eax
8010582f:	50                   	push   %eax
80105830:	e8 2b f3 ff ff       	call   80104b60 <fetchint>
80105835:	83 c4 10             	add    $0x10,%esp
80105838:	85 c0                	test   %eax,%eax
8010583a:	79 b4                	jns    801057f0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010583c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010583f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105844:	5b                   	pop    %ebx
80105845:	5e                   	pop    %esi
80105846:	5f                   	pop    %edi
80105847:	5d                   	pop    %ebp
80105848:	c3                   	ret    
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105850:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105856:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105859:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105860:	00 00 00 00 
  return exec(path, argv);
80105864:	50                   	push   %eax
80105865:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010586b:	e8 90 b1 ff ff       	call   80100a00 <exec>
80105870:	83 c4 10             	add    $0x10,%esp
}
80105873:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105876:	5b                   	pop    %ebx
80105877:	5e                   	pop    %esi
80105878:	5f                   	pop    %edi
80105879:	5d                   	pop    %ebp
8010587a:	c3                   	ret    
8010587b:	90                   	nop
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_pipe>:

int
sys_pipe(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
80105885:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105886:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105889:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010588c:	6a 08                	push   $0x8
8010588e:	50                   	push   %eax
8010588f:	6a 00                	push   $0x0
80105891:	e8 ca f3 ff ff       	call   80104c60 <argptr>
80105896:	83 c4 10             	add    $0x10,%esp
80105899:	85 c0                	test   %eax,%eax
8010589b:	0f 88 ae 00 00 00    	js     8010594f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058a4:	83 ec 08             	sub    $0x8,%esp
801058a7:	50                   	push   %eax
801058a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058ab:	50                   	push   %eax
801058ac:	e8 6f da ff ff       	call   80103320 <pipealloc>
801058b1:	83 c4 10             	add    $0x10,%esp
801058b4:	85 c0                	test   %eax,%eax
801058b6:	0f 88 93 00 00 00    	js     8010594f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058bc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058bf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058c1:	e8 ca df ff ff       	call   80103890 <myproc>
801058c6:	eb 10                	jmp    801058d8 <sys_pipe+0x58>
801058c8:	90                   	nop
801058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058d0:	83 c3 01             	add    $0x1,%ebx
801058d3:	83 fb 10             	cmp    $0x10,%ebx
801058d6:	74 60                	je     80105938 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801058d8:	8b 74 98 1c          	mov    0x1c(%eax,%ebx,4),%esi
801058dc:	85 f6                	test   %esi,%esi
801058de:	75 f0                	jne    801058d0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801058e0:	8d 73 04             	lea    0x4(%ebx),%esi
801058e3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ea:	e8 a1 df ff ff       	call   80103890 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ef:	31 d2                	xor    %edx,%edx
801058f1:	eb 0d                	jmp    80105900 <sys_pipe+0x80>
801058f3:	90                   	nop
801058f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058f8:	83 c2 01             	add    $0x1,%edx
801058fb:	83 fa 10             	cmp    $0x10,%edx
801058fe:	74 28                	je     80105928 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105900:	8b 4c 90 1c          	mov    0x1c(%eax,%edx,4),%ecx
80105904:	85 c9                	test   %ecx,%ecx
80105906:	75 f0                	jne    801058f8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105908:	89 7c 90 1c          	mov    %edi,0x1c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010590c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010590f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105911:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105914:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105917:	31 c0                	xor    %eax,%eax
}
80105919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010591c:	5b                   	pop    %ebx
8010591d:	5e                   	pop    %esi
8010591e:	5f                   	pop    %edi
8010591f:	5d                   	pop    %ebp
80105920:	c3                   	ret    
80105921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105928:	e8 63 df ff ff       	call   80103890 <myproc>
8010592d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105934:	00 
80105935:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105938:	83 ec 0c             	sub    $0xc,%esp
8010593b:	ff 75 e0             	pushl  -0x20(%ebp)
8010593e:	e8 dd b5 ff ff       	call   80100f20 <fileclose>
    fileclose(wf);
80105943:	58                   	pop    %eax
80105944:	ff 75 e4             	pushl  -0x1c(%ebp)
80105947:	e8 d4 b5 ff ff       	call   80100f20 <fileclose>
    return -1;
8010594c:	83 c4 10             	add    $0x10,%esp
8010594f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105954:	eb c3                	jmp    80105919 <sys_pipe+0x99>
80105956:	66 90                	xchg   %ax,%ax
80105958:	66 90                	xchg   %ax,%ax
8010595a:	66 90                	xchg   %ax,%ax
8010595c:	66 90                	xchg   %ax,%ax
8010595e:	66 90                	xchg   %ax,%ax

80105960 <sys_yield>:
#include "proc.h"

// Operating_Systems_Projects01
int
sys_yield(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 08             	sub    $0x8,%esp
  yield();
80105966:	e8 85 24 00 00       	call   80107df0 <yield>
  return 0;
}
8010596b:	31 c0                	xor    %eax,%eax
8010596d:	c9                   	leave  
8010596e:	c3                   	ret    
8010596f:	90                   	nop

80105970 <sys_getlev>:

int
sys_getlev(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 08             	sub    $0x8,%esp
  if(myproc()->stype == MLFQ)
80105976:	e8 15 df ff ff       	call   80103890 <myproc>
8010597b:	83 78 70 01          	cmpl   $0x1,0x70(%eax)
8010597f:	75 0f                	jne    80105990 <sys_getlev+0x20>
    return myproc()->qlev;
80105981:	e8 0a df ff ff       	call   80103890 <myproc>
80105986:	8b 40 74             	mov    0x74(%eax),%eax

  return -1;
}
80105989:	c9                   	leave  
8010598a:	c3                   	ret    
8010598b:	90                   	nop
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105995:	c9                   	leave  
80105996:	c3                   	ret    
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059a0 <sys_set_cpu_share>:

int
sys_set_cpu_share(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 20             	sub    $0x20,%esp
  int n;
  if (argint(0, &n) < 0)
801059a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059a9:	50                   	push   %eax
801059aa:	6a 00                	push   $0x0
801059ac:	e8 5f f2 ff ff       	call   80104c10 <argint>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	85 c0                	test   %eax,%eax
801059b6:	78 18                	js     801059d0 <sys_set_cpu_share+0x30>
    return -1;
  return set_cpu_share(n);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	ff 75 f4             	pushl  -0xc(%ebp)
801059be:	e8 7d 24 00 00       	call   80107e40 <set_cpu_share>
801059c3:	83 c4 10             	add    $0x10,%esp
}
801059c6:	c9                   	leave  
801059c7:	c3                   	ret    
801059c8:	90                   	nop
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <sys_thread_create>:


// Operating_Systems_Projects02
int
sys_thread_create(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 20             	sub    $0x20,%esp
  int i, argv[3];
  for (i = 0; i < 3; i++)
    if (argint(i, &argv[i]) < 0)
801059e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059e9:	50                   	push   %eax
801059ea:	6a 00                	push   $0x0
801059ec:	e8 1f f2 ff ff       	call   80104c10 <argint>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	78 48                	js     80105a40 <sys_thread_create+0x60>
801059f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059fb:	83 ec 08             	sub    $0x8,%esp
801059fe:	50                   	push   %eax
801059ff:	6a 01                	push   $0x1
80105a01:	e8 0a f2 ff ff       	call   80104c10 <argint>
80105a06:	83 c4 10             	add    $0x10,%esp
80105a09:	85 c0                	test   %eax,%eax
80105a0b:	78 33                	js     80105a40 <sys_thread_create+0x60>
80105a0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a10:	83 ec 08             	sub    $0x8,%esp
80105a13:	50                   	push   %eax
80105a14:	6a 02                	push   $0x2
80105a16:	e8 f5 f1 ff ff       	call   80104c10 <argint>
80105a1b:	83 c4 10             	add    $0x10,%esp
80105a1e:	85 c0                	test   %eax,%eax
80105a20:	78 1e                	js     80105a40 <sys_thread_create+0x60>
      return -1;
  return thread_create((thread_t*)argv[0], (void* (*)(void*))argv[1], (void*) argv[2]);
80105a22:	83 ec 04             	sub    $0x4,%esp
80105a25:	ff 75 f4             	pushl  -0xc(%ebp)
80105a28:	ff 75 f0             	pushl  -0x10(%ebp)
80105a2b:	ff 75 ec             	pushl  -0x14(%ebp)
80105a2e:	e8 9d 26 00 00       	call   801080d0 <thread_create>
80105a33:	83 c4 10             	add    $0x10,%esp
}
80105a36:	c9                   	leave  
80105a37:	c3                   	ret    
80105a38:	90                   	nop
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a45:	c9                   	leave  
80105a46:	c3                   	ret    
80105a47:	89 f6                	mov    %esi,%esi
80105a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a50 <sys_thread_exit>:

int
sys_thread_exit(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 20             	sub    $0x20,%esp
  int n;
    if (argint(0, &n) < 0)
80105a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a59:	50                   	push   %eax
80105a5a:	6a 00                	push   $0x0
80105a5c:	e8 af f1 ff ff       	call   80104c10 <argint>
80105a61:	83 c4 10             	add    $0x10,%esp
80105a64:	85 c0                	test   %eax,%eax
80105a66:	78 18                	js     80105a80 <sys_thread_exit+0x30>
      return -1;
  thread_exit((void*)n);
80105a68:	83 ec 0c             	sub    $0xc,%esp
80105a6b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a6e:	e8 ad 27 00 00       	call   80108220 <thread_exit>
  return 0;
80105a73:	83 c4 10             	add    $0x10,%esp
80105a76:	31 c0                	xor    %eax,%eax
}
80105a78:	c9                   	leave  
80105a79:	c3                   	ret    
80105a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return -1;
80105a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a85:	c9                   	leave  
80105a86:	c3                   	ret    
80105a87:	89 f6                	mov    %esi,%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a90 <sys_thread_join>:

int
sys_thread_join(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	83 ec 20             	sub    $0x20,%esp
  int i, argv[2];
  for (i = 0; i < 2; i++)
    if (argint(i, &argv[i]) < 0)
80105a96:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a99:	50                   	push   %eax
80105a9a:	6a 00                	push   $0x0
80105a9c:	e8 6f f1 ff ff       	call   80104c10 <argint>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	85 c0                	test   %eax,%eax
80105aa6:	78 28                	js     80105ad0 <sys_thread_join+0x40>
80105aa8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aab:	83 ec 08             	sub    $0x8,%esp
80105aae:	50                   	push   %eax
80105aaf:	6a 01                	push   $0x1
80105ab1:	e8 5a f1 ff ff       	call   80104c10 <argint>
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	78 13                	js     80105ad0 <sys_thread_join+0x40>
      return -1;
  return thread_join((thread_t)argv[0], (void**)argv[1]);
80105abd:	83 ec 08             	sub    $0x8,%esp
80105ac0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ac3:	ff 75 f0             	pushl  -0x10(%ebp)
80105ac6:	e8 05 28 00 00       	call   801082d0 <thread_join>
80105acb:	83 c4 10             	add    $0x10,%esp
}
80105ace:	c9                   	leave  
80105acf:	c3                   	ret    
      return -1;
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad5:	c9                   	leave  
80105ad6:	c3                   	ret    
80105ad7:	89 f6                	mov    %esi,%esi
80105ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ae0 <sys_fork>:

int
sys_fork(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ae3:	5d                   	pop    %ebp
  return fork();
80105ae4:	e9 f7 df ff ff       	jmp    80103ae0 <fork>
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105af0 <sys_exit>:

int
sys_exit(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105af6:	e8 05 e5 ff ff       	call   80104000 <exit>
  return 0;  // not reached
}
80105afb:	31 c0                	xor    %eax,%eax
80105afd:	c9                   	leave  
80105afe:	c3                   	ret    
80105aff:	90                   	nop

80105b00 <sys_wait>:

int
sys_wait(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105b03:	5d                   	pop    %ebp
  return wait();
80105b04:	e9 f7 e2 ff ff       	jmp    80103e00 <wait>
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b10 <sys_kill>:

int
sys_kill(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b19:	50                   	push   %eax
80105b1a:	6a 00                	push   $0x0
80105b1c:	e8 ef f0 ff ff       	call   80104c10 <argint>
80105b21:	83 c4 10             	add    $0x10,%esp
80105b24:	85 c0                	test   %eax,%eax
80105b26:	78 18                	js     80105b40 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b28:	83 ec 0c             	sub    $0xc,%esp
80105b2b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b2e:	e8 5d e6 ff ff       	call   80104190 <kill>
80105b33:	83 c4 10             	add    $0x10,%esp
}
80105b36:	c9                   	leave  
80105b37:	c3                   	ret    
80105b38:	90                   	nop
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b45:	c9                   	leave  
80105b46:	c3                   	ret    
80105b47:	89 f6                	mov    %esi,%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b50 <sys_getpid>:

int
sys_getpid(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b56:	e8 35 dd ff ff       	call   80103890 <myproc>
80105b5b:	8b 40 0c             	mov    0xc(%eax),%eax
}
80105b5e:	c9                   	leave  
80105b5f:	c3                   	ret    

80105b60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b6a:	50                   	push   %eax
80105b6b:	6a 00                	push   $0x0
80105b6d:	e8 9e f0 ff ff       	call   80104c10 <argint>
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	85 c0                	test   %eax,%eax
80105b77:	78 27                	js     80105ba0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b79:	e8 12 dd ff ff       	call   80103890 <myproc>
  if(growproc(n) < 0)
80105b7e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105b81:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b83:	ff 75 f4             	pushl  -0xc(%ebp)
80105b86:	e8 d5 de ff ff       	call   80103a60 <growproc>
80105b8b:	83 c4 10             	add    $0x10,%esp
80105b8e:	85 c0                	test   %eax,%eax
80105b90:	78 0e                	js     80105ba0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105b92:	89 d8                	mov    %ebx,%eax
80105b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b97:	c9                   	leave  
80105b98:	c3                   	ret    
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ba0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ba5:	eb eb                	jmp    80105b92 <sys_sbrk+0x32>
80105ba7:	89 f6                	mov    %esi,%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bb0 <sys_sleep>:

int
sys_sleep(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105bb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bb7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bba:	50                   	push   %eax
80105bbb:	6a 00                	push   $0x0
80105bbd:	e8 4e f0 ff ff       	call   80104c10 <argint>
80105bc2:	83 c4 10             	add    $0x10,%esp
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	0f 88 92 00 00 00    	js     80105c5f <sys_sleep+0xaf>
    return -1;
  acquire(&tickslock);
80105bcd:	83 ec 0c             	sub    $0xc,%esp
80105bd0:	68 a0 80 11 80       	push   $0x801180a0
80105bd5:	e8 26 ec ff ff       	call   80104800 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105bda:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105bdd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105be0:	8b 1d e0 88 11 80    	mov    0x801188e0,%ebx
  while(ticks - ticks0 < n){
80105be6:	85 c9                	test   %ecx,%ecx
80105be8:	75 33                	jne    80105c1d <sys_sleep+0x6d>
80105bea:	eb 5c                	jmp    80105c48 <sys_sleep+0x98>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
//    if(myproc()->killed){
    if(myproc()->killed || myproc()->exited){
80105bf0:	e8 9b dc ff ff       	call   80103890 <myproc>
80105bf5:	8b 40 18             	mov    0x18(%eax),%eax
80105bf8:	85 c0                	test   %eax,%eax
80105bfa:	75 2d                	jne    80105c29 <sys_sleep+0x79>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105bfc:	83 ec 08             	sub    $0x8,%esp
80105bff:	68 a0 80 11 80       	push   $0x801180a0
80105c04:	68 e0 88 11 80       	push   $0x801188e0
80105c09:	e8 f2 e0 ff ff       	call   80103d00 <sleep>
  while(ticks - ticks0 < n){
80105c0e:	a1 e0 88 11 80       	mov    0x801188e0,%eax
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	29 d8                	sub    %ebx,%eax
80105c18:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c1b:	73 2b                	jae    80105c48 <sys_sleep+0x98>
    if(myproc()->killed || myproc()->exited){
80105c1d:	e8 6e dc ff ff       	call   80103890 <myproc>
80105c22:	8b 50 14             	mov    0x14(%eax),%edx
80105c25:	85 d2                	test   %edx,%edx
80105c27:	74 c7                	je     80105bf0 <sys_sleep+0x40>
      release(&tickslock);
80105c29:	83 ec 0c             	sub    $0xc,%esp
80105c2c:	68 a0 80 11 80       	push   $0x801180a0
80105c31:	e8 8a ec ff ff       	call   801048c0 <release>
      return -1;
80105c36:	83 c4 10             	add    $0x10,%esp
80105c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105c3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c41:	c9                   	leave  
80105c42:	c3                   	ret    
80105c43:	90                   	nop
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	68 a0 80 11 80       	push   $0x801180a0
80105c50:	e8 6b ec ff ff       	call   801048c0 <release>
  return 0;
80105c55:	83 c4 10             	add    $0x10,%esp
80105c58:	31 c0                	xor    %eax,%eax
}
80105c5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c5d:	c9                   	leave  
80105c5e:	c3                   	ret    
    return -1;
80105c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c64:	eb d8                	jmp    80105c3e <sys_sleep+0x8e>
80105c66:	8d 76 00             	lea    0x0(%esi),%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	53                   	push   %ebx
80105c74:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c77:	68 a0 80 11 80       	push   $0x801180a0
80105c7c:	e8 7f eb ff ff       	call   80104800 <acquire>
  xticks = ticks;
80105c81:	8b 1d e0 88 11 80    	mov    0x801188e0,%ebx
  release(&tickslock);
80105c87:	c7 04 24 a0 80 11 80 	movl   $0x801180a0,(%esp)
80105c8e:	e8 2d ec ff ff       	call   801048c0 <release>
  return xticks;
}
80105c93:	89 d8                	mov    %ebx,%eax
80105c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c98:	c9                   	leave  
80105c99:	c3                   	ret    
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ca0 <sys_xem_init>:

int
sys_xem_init(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 20             	sub    $0x20,%esp
    int argv[1];

    if (argint(0, &argv[0]) < 0)
80105ca6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ca9:	50                   	push   %eax
80105caa:	6a 00                	push   $0x0
80105cac:	e8 5f ef ff ff       	call   80104c10 <argint>
80105cb1:	83 c4 10             	add    $0x10,%esp
80105cb4:	85 c0                	test   %eax,%eax
80105cb6:	78 18                	js     80105cd0 <sys_xem_init+0x30>
        return -1;

    return xem_init((xem_t*)argv[0]);
80105cb8:	83 ec 0c             	sub    $0xc,%esp
80105cbb:	ff 75 f4             	pushl  -0xc(%ebp)
80105cbe:	e8 8d e6 ff ff       	call   80104350 <xem_init>
80105cc3:	83 c4 10             	add    $0x10,%esp
}
80105cc6:	c9                   	leave  
80105cc7:	c3                   	ret    
80105cc8:	90                   	nop
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cd5:	c9                   	leave  
80105cd6:	c3                   	ret    
80105cd7:	89 f6                	mov    %esi,%esi
80105cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ce0 <sys_xem_wait>:

int
sys_xem_wait(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 20             	sub    $0x20,%esp
    int argv[1];

    if (argint(0, &argv[0]) < 0)
80105ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce9:	50                   	push   %eax
80105cea:	6a 00                	push   $0x0
80105cec:	e8 1f ef ff ff       	call   80104c10 <argint>
80105cf1:	83 c4 10             	add    $0x10,%esp
80105cf4:	85 c0                	test   %eax,%eax
80105cf6:	78 18                	js     80105d10 <sys_xem_wait+0x30>
        return -1;

    return xem_wait((xem_t*)argv[0]);
80105cf8:	83 ec 0c             	sub    $0xc,%esp
80105cfb:	ff 75 f4             	pushl  -0xc(%ebp)
80105cfe:	e8 9d e6 ff ff       	call   801043a0 <xem_wait>
80105d03:	83 c4 10             	add    $0x10,%esp
}
80105d06:	c9                   	leave  
80105d07:	c3                   	ret    
80105d08:	90                   	nop
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d20 <sys_xem_unlock>:

int sys_xem_unlock(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	83 ec 20             	sub    $0x20,%esp
    int argv[1];

    if (argint(0, &argv[0]) < 0)
80105d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d29:	50                   	push   %eax
80105d2a:	6a 00                	push   $0x0
80105d2c:	e8 df ee ff ff       	call   80104c10 <argint>
80105d31:	83 c4 10             	add    $0x10,%esp
80105d34:	85 c0                	test   %eax,%eax
80105d36:	78 18                	js     80105d50 <sys_xem_unlock+0x30>
        return -1;

    return xem_unlock((xem_t*)argv[0]);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d3e:	e8 bd e6 ff ff       	call   80104400 <xem_unlock>
80105d43:	83 c4 10             	add    $0x10,%esp
}
80105d46:	c9                   	leave  
80105d47:	c3                   	ret    
80105d48:	90                   	nop
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d55:	c9                   	leave  
80105d56:	c3                   	ret    
80105d57:	89 f6                	mov    %esi,%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d60 <sys_rwlock_init>:

int sys_rwlock_init(void) 
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 20             	sub    $0x20,%esp
    int argv[1];

    if (argint(0, &argv[0]) < 0)
80105d66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d69:	50                   	push   %eax
80105d6a:	6a 00                	push   $0x0
80105d6c:	e8 9f ee ff ff       	call   80104c10 <argint>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	85 c0                	test   %eax,%eax
80105d76:	78 18                	js     80105d90 <sys_rwlock_init+0x30>
        return -1;

    return rwlock_init((rwlock_t*) argv[0]);
80105d78:	83 ec 0c             	sub    $0xc,%esp
80105d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7e:	e8 ad e6 ff ff       	call   80104430 <rwlock_init>
80105d83:	83 c4 10             	add    $0x10,%esp
}
80105d86:	c9                   	leave  
80105d87:	c3                   	ret    
80105d88:	90                   	nop
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <sys_rwlock_acquire_readlock>:

int sys_rwlock_acquire_readlock(void) 
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 20             	sub    $0x20,%esp
    int argv[1];

    if (argint(0, &argv[0]) < 0)
80105da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105da9:	50                   	push   %eax
80105daa:	6a 00                	push   $0x0
80105dac:	e8 5f ee ff ff       	call   80104c10 <argint>
80105db1:	83 c4 10             	add    $0x10,%esp
80105db4:	85 c0                	test   %eax,%eax
80105db6:	78 18                	js     80105dd0 <sys_rwlock_acquire_readlock+0x30>
        return -1;

    return rwlock_acquire_readlock((rwlock_t*)argv[0]);
80105db8:	83 ec 0c             	sub    $0xc,%esp
80105dbb:	ff 75 f4             	pushl  -0xc(%ebp)
80105dbe:	e8 9d e6 ff ff       	call   80104460 <rwlock_acquire_readlock>
80105dc3:	83 c4 10             	add    $0x10,%esp
}
80105dc6:	c9                   	leave  
80105dc7:	c3                   	ret    
80105dc8:	90                   	nop
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dd5:	c9                   	leave  
80105dd6:	c3                   	ret    
80105dd7:	89 f6                	mov    %esi,%esi
80105dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105de0 <sys_rwlock_acquire_writelock>:

int sys_rwlock_acquire_writelock(void) 
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	83 ec 20             	sub    $0x20,%esp
    int argv[1];

    if (argint(0, &argv[0]) < 0)
80105de6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de9:	50                   	push   %eax
80105dea:	6a 00                	push   $0x0
80105dec:	e8 1f ee ff ff       	call   80104c10 <argint>
80105df1:	83 c4 10             	add    $0x10,%esp
80105df4:	85 c0                	test   %eax,%eax
80105df6:	78 18                	js     80105e10 <sys_rwlock_acquire_writelock+0x30>
        return -1;

    return rwlock_acquire_writelock((rwlock_t*)argv[0]);
80105df8:	83 ec 0c             	sub    $0xc,%esp
80105dfb:	ff 75 f4             	pushl  -0xc(%ebp)
80105dfe:	e8 cd e6 ff ff       	call   801044d0 <rwlock_acquire_writelock>
80105e03:	83 c4 10             	add    $0x10,%esp
}
80105e06:	c9                   	leave  
80105e07:	c3                   	ret    
80105e08:	90                   	nop
80105e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e15:	c9                   	leave  
80105e16:	c3                   	ret    
80105e17:	89 f6                	mov    %esi,%esi
80105e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e20 <sys_rwlock_release_readlock>:

int sys_rwlock_release_readlock(void) 
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	83 ec 20             	sub    $0x20,%esp
    int argv[1];

    if (argint(0, &argv[0]) < 0)
80105e26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e29:	50                   	push   %eax
80105e2a:	6a 00                	push   $0x0
80105e2c:	e8 df ed ff ff       	call   80104c10 <argint>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	85 c0                	test   %eax,%eax
80105e36:	78 18                	js     80105e50 <sys_rwlock_release_readlock+0x30>
        return -1;


    return rwlock_release_readlock((rwlock_t*)argv[0]);
80105e38:	83 ec 0c             	sub    $0xc,%esp
80105e3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e3e:	e8 ad e6 ff ff       	call   801044f0 <rwlock_release_readlock>
80105e43:	83 c4 10             	add    $0x10,%esp
}
80105e46:	c9                   	leave  
80105e47:	c3                   	ret    
80105e48:	90                   	nop
80105e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e55:	c9                   	leave  
80105e56:	c3                   	ret    
80105e57:	89 f6                	mov    %esi,%esi
80105e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e60 <sys_rwlock_release_writelock>:

int sys_rwlock_release_writelock(void) 
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 20             	sub    $0x20,%esp
    int argv[1];

    if (argint(0, &argv[0]) < 0)
80105e66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e69:	50                   	push   %eax
80105e6a:	6a 00                	push   $0x0
80105e6c:	e8 9f ed ff ff       	call   80104c10 <argint>
80105e71:	83 c4 10             	add    $0x10,%esp
80105e74:	85 c0                	test   %eax,%eax
80105e76:	78 18                	js     80105e90 <sys_rwlock_release_writelock+0x30>
        return -1;

    return rwlock_relaese_writelock((rwlock_t*)argv[0]);
80105e78:	83 ec 0c             	sub    $0xc,%esp
80105e7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e7e:	e8 dd e6 ff ff       	call   80104560 <rwlock_relaese_writelock>
80105e83:	83 c4 10             	add    $0x10,%esp
80105e86:	c9                   	leave  
80105e87:	c3                   	ret    
80105e88:	90                   	nop
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    

80105e97 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e97:	1e                   	push   %ds
  pushl %es
80105e98:	06                   	push   %es
  pushl %fs
80105e99:	0f a0                	push   %fs
  pushl %gs
80105e9b:	0f a8                	push   %gs
  pushal
80105e9d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e9e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ea2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ea4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ea6:	54                   	push   %esp
  call trap
80105ea7:	e8 c4 00 00 00       	call   80105f70 <trap>
  addl $4, %esp
80105eac:	83 c4 04             	add    $0x4,%esp

80105eaf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105eaf:	61                   	popa   
  popl %gs
80105eb0:	0f a9                	pop    %gs
  popl %fs
80105eb2:	0f a1                	pop    %fs
  popl %es
80105eb4:	07                   	pop    %es
  popl %ds
80105eb5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105eb6:	83 c4 08             	add    $0x8,%esp
  iret
80105eb9:	cf                   	iret   
80105eba:	66 90                	xchg   %ax,%ax
80105ebc:	66 90                	xchg   %ax,%ax
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ec0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ec1:	31 c0                	xor    %eax,%eax
{
80105ec3:	89 e5                	mov    %esp,%ebp
80105ec5:	83 ec 08             	sub    $0x8,%esp
80105ec8:	90                   	nop
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ed0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ed7:	c7 04 c5 e2 80 11 80 	movl   $0x8e000008,-0x7fee7f1e(,%eax,8)
80105ede:	08 00 00 8e 
80105ee2:	66 89 14 c5 e0 80 11 	mov    %dx,-0x7fee7f20(,%eax,8)
80105ee9:	80 
80105eea:	c1 ea 10             	shr    $0x10,%edx
80105eed:	66 89 14 c5 e6 80 11 	mov    %dx,-0x7fee7f1a(,%eax,8)
80105ef4:	80 
  for(i = 0; i < 256; i++)
80105ef5:	83 c0 01             	add    $0x1,%eax
80105ef8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105efd:	75 d1                	jne    80105ed0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105eff:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105f04:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f07:	c7 05 e2 82 11 80 08 	movl   $0xef000008,0x801182e2
80105f0e:	00 00 ef 
  initlock(&tickslock, "time");
80105f11:	68 d1 8b 10 80       	push   $0x80108bd1
80105f16:	68 a0 80 11 80       	push   $0x801180a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f1b:	66 a3 e0 82 11 80    	mov    %ax,0x801182e0
80105f21:	c1 e8 10             	shr    $0x10,%eax
80105f24:	66 a3 e6 82 11 80    	mov    %ax,0x801182e6
  initlock(&tickslock, "time");
80105f2a:	e8 91 e7 ff ff       	call   801046c0 <initlock>
}
80105f2f:	83 c4 10             	add    $0x10,%esp
80105f32:	c9                   	leave  
80105f33:	c3                   	ret    
80105f34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f40 <idtinit>:

void
idtinit(void)
{
80105f40:	55                   	push   %ebp
  pd[0] = size-1;
80105f41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f46:	89 e5                	mov    %esp,%ebp
80105f48:	83 ec 10             	sub    $0x10,%esp
80105f4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f4f:	b8 e0 80 11 80       	mov    $0x801180e0,%eax
80105f54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f58:	c1 e8 10             	shr    $0x10,%eax
80105f5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f65:	c9                   	leave  
80105f66:	c3                   	ret    
80105f67:	89 f6                	mov    %esi,%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	57                   	push   %edi
80105f74:	56                   	push   %esi
80105f75:	53                   	push   %ebx
80105f76:	83 ec 1c             	sub    $0x1c,%esp
80105f79:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105f7c:	8b 47 30             	mov    0x30(%edi),%eax
80105f7f:	83 f8 40             	cmp    $0x40,%eax
80105f82:	0f 84 f8 00 00 00    	je     80106080 <trap+0x110>
    if(myproc()->killed || myproc()->exited)
      thread_exit(0);
    return;
  }

  switch(tf->trapno){
80105f88:	83 e8 20             	sub    $0x20,%eax
80105f8b:	83 f8 1f             	cmp    $0x1f,%eax
80105f8e:	77 10                	ja     80105fa0 <trap+0x30>
80105f90:	ff 24 85 78 8c 10 80 	jmp    *-0x7fef7388(,%eax,4)
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105fa0:	e8 eb d8 ff ff       	call   80103890 <myproc>
80105fa5:	85 c0                	test   %eax,%eax
80105fa7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105faa:	0f 84 84 02 00 00    	je     80106234 <trap+0x2c4>
80105fb0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105fb4:	0f 84 7a 02 00 00    	je     80106234 <trap+0x2c4>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fba:	0f 20 d1             	mov    %cr2,%ecx
80105fbd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fc0:	e8 ab d8 ff ff       	call   80103870 <cpuid>
80105fc5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105fc8:	8b 47 34             	mov    0x34(%edi),%eax
80105fcb:	8b 77 30             	mov    0x30(%edi),%esi
80105fce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fd1:	e8 ba d8 ff ff       	call   80103890 <myproc>
80105fd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fd9:	e8 b2 d8 ff ff       	call   80103890 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fde:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105fe1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fe4:	51                   	push   %ecx
80105fe5:	53                   	push   %ebx
80105fe6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105fe7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fea:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fed:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105fee:	83 c2 60             	add    $0x60,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ff1:	52                   	push   %edx
80105ff2:	ff 70 0c             	pushl  0xc(%eax)
80105ff5:	68 34 8c 10 80       	push   $0x80108c34
80105ffa:	e8 51 a6 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105fff:	83 c4 20             	add    $0x20,%esp
80106002:	e8 89 d8 ff ff       	call   80103890 <myproc>
80106007:	c7 40 14 01 00 00 00 	movl   $0x1,0x14(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && (myproc()->killed || myproc()->exited) && (tf->cs&3) == DPL_USER)
8010600e:	e8 7d d8 ff ff       	call   80103890 <myproc>
80106013:	85 c0                	test   %eax,%eax
80106015:	74 21                	je     80106038 <trap+0xc8>
80106017:	e8 74 d8 ff ff       	call   80103890 <myproc>
8010601c:	8b 58 14             	mov    0x14(%eax),%ebx
8010601f:	85 db                	test   %ebx,%ebx
80106021:	0f 84 c1 01 00 00    	je     801061e8 <trap+0x278>
80106027:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010602b:	83 e0 03             	and    $0x3,%eax
8010602e:	66 83 f8 03          	cmp    $0x3,%ax
80106032:	0f 84 80 01 00 00    	je     801061b8 <trap+0x248>
    thread_exit(0);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && mythd()->state == RUNNING &&
80106038:	e8 53 d8 ff ff       	call   80103890 <myproc>
8010603d:	85 c0                	test   %eax,%eax
8010603f:	74 0f                	je     80106050 <trap+0xe0>
80106041:	e8 7a d8 ff ff       	call   801038c0 <mythd>
80106046:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
8010604a:	0f 84 88 00 00 00    	je     801060d8 <trap+0x168>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && (myproc()->killed || myproc()->exited) && (tf->cs&3) == DPL_USER)
80106050:	e8 3b d8 ff ff       	call   80103890 <myproc>
80106055:	85 c0                	test   %eax,%eax
80106057:	74 1d                	je     80106076 <trap+0x106>
80106059:	e8 32 d8 ff ff       	call   80103890 <myproc>
8010605e:	8b 50 14             	mov    0x14(%eax),%edx
80106061:	85 d2                	test   %edx,%edx
80106063:	0f 84 67 01 00 00    	je     801061d0 <trap+0x260>
80106069:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010606d:	83 e0 03             	and    $0x3,%eax
80106070:	66 83 f8 03          	cmp    $0x3,%ax
80106074:	74 4c                	je     801060c2 <trap+0x152>
    thread_exit(0);
}
80106076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106079:	5b                   	pop    %ebx
8010607a:	5e                   	pop    %esi
8010607b:	5f                   	pop    %edi
8010607c:	5d                   	pop    %ebp
8010607d:	c3                   	ret    
8010607e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed || myproc()->exited)
80106080:	e8 0b d8 ff ff       	call   80103890 <myproc>
80106085:	8b 40 14             	mov    0x14(%eax),%eax
80106088:	85 c0                	test   %eax,%eax
8010608a:	0f 84 10 01 00 00    	je     801061a0 <trap+0x230>
      thread_exit(0);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	6a 00                	push   $0x0
80106095:	e8 86 21 00 00       	call   80108220 <thread_exit>
8010609a:	83 c4 10             	add    $0x10,%esp
    mythd()->tf = tf;
8010609d:	e8 1e d8 ff ff       	call   801038c0 <mythd>
801060a2:	89 78 14             	mov    %edi,0x14(%eax)
    syscall();
801060a5:	e8 56 ec ff ff       	call   80104d00 <syscall>
    if(myproc()->killed || myproc()->exited)
801060aa:	e8 e1 d7 ff ff       	call   80103890 <myproc>
801060af:	8b 78 14             	mov    0x14(%eax),%edi
801060b2:	85 ff                	test   %edi,%edi
801060b4:	75 0c                	jne    801060c2 <trap+0x152>
801060b6:	e8 d5 d7 ff ff       	call   80103890 <myproc>
801060bb:	8b 70 18             	mov    0x18(%eax),%esi
801060be:	85 f6                	test   %esi,%esi
801060c0:	74 b4                	je     80106076 <trap+0x106>
      thread_exit(0);
801060c2:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
801060c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060cc:	5b                   	pop    %ebx
801060cd:	5e                   	pop    %esi
801060ce:	5f                   	pop    %edi
801060cf:	5d                   	pop    %ebp
      thread_exit(0);
801060d0:	e9 4b 21 00 00       	jmp    80108220 <thread_exit>
801060d5:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && mythd()->state == RUNNING &&
801060d8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801060dc:	0f 85 6e ff ff ff    	jne    80106050 <trap+0xe0>
    yield();
801060e2:	e8 09 1d 00 00       	call   80107df0 <yield>
801060e7:	e9 64 ff ff ff       	jmp    80106050 <trap+0xe0>
801060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801060f0:	e8 7b d7 ff ff       	call   80103870 <cpuid>
801060f5:	85 c0                	test   %eax,%eax
801060f7:	0f 84 03 01 00 00    	je     80106200 <trap+0x290>
    lapiceoi();
801060fd:	e8 2e c7 ff ff       	call   80102830 <lapiceoi>
  if(myproc() && (myproc()->killed || myproc()->exited) && (tf->cs&3) == DPL_USER)
80106102:	e8 89 d7 ff ff       	call   80103890 <myproc>
80106107:	85 c0                	test   %eax,%eax
80106109:	0f 85 08 ff ff ff    	jne    80106017 <trap+0xa7>
8010610f:	e9 24 ff ff ff       	jmp    80106038 <trap+0xc8>
80106114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106118:	e8 d3 c5 ff ff       	call   801026f0 <kbdintr>
    lapiceoi();
8010611d:	e8 0e c7 ff ff       	call   80102830 <lapiceoi>
  if(myproc() && (myproc()->killed || myproc()->exited) && (tf->cs&3) == DPL_USER)
80106122:	e8 69 d7 ff ff       	call   80103890 <myproc>
80106127:	85 c0                	test   %eax,%eax
80106129:	0f 85 e8 fe ff ff    	jne    80106017 <trap+0xa7>
8010612f:	e9 04 ff ff ff       	jmp    80106038 <trap+0xc8>
80106134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106138:	e8 93 02 00 00       	call   801063d0 <uartintr>
    lapiceoi();
8010613d:	e8 ee c6 ff ff       	call   80102830 <lapiceoi>
  if(myproc() && (myproc()->killed || myproc()->exited) && (tf->cs&3) == DPL_USER)
80106142:	e8 49 d7 ff ff       	call   80103890 <myproc>
80106147:	85 c0                	test   %eax,%eax
80106149:	0f 85 c8 fe ff ff    	jne    80106017 <trap+0xa7>
8010614f:	e9 e4 fe ff ff       	jmp    80106038 <trap+0xc8>
80106154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106158:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010615c:	8b 77 38             	mov    0x38(%edi),%esi
8010615f:	e8 0c d7 ff ff       	call   80103870 <cpuid>
80106164:	56                   	push   %esi
80106165:	53                   	push   %ebx
80106166:	50                   	push   %eax
80106167:	68 dc 8b 10 80       	push   $0x80108bdc
8010616c:	e8 df a4 ff ff       	call   80100650 <cprintf>
    lapiceoi();
80106171:	e8 ba c6 ff ff       	call   80102830 <lapiceoi>
    break;
80106176:	83 c4 10             	add    $0x10,%esp
  if(myproc() && (myproc()->killed || myproc()->exited) && (tf->cs&3) == DPL_USER)
80106179:	e8 12 d7 ff ff       	call   80103890 <myproc>
8010617e:	85 c0                	test   %eax,%eax
80106180:	0f 85 91 fe ff ff    	jne    80106017 <trap+0xa7>
80106186:	e9 ad fe ff ff       	jmp    80106038 <trap+0xc8>
8010618b:	90                   	nop
8010618c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106190:	e8 cb bf ff ff       	call   80102160 <ideintr>
80106195:	e9 63 ff ff ff       	jmp    801060fd <trap+0x18d>
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed || myproc()->exited)
801061a0:	e8 eb d6 ff ff       	call   80103890 <myproc>
801061a5:	8b 40 18             	mov    0x18(%eax),%eax
801061a8:	85 c0                	test   %eax,%eax
801061aa:	0f 85 e0 fe ff ff    	jne    80106090 <trap+0x120>
801061b0:	e9 e8 fe ff ff       	jmp    8010609d <trap+0x12d>
801061b5:	8d 76 00             	lea    0x0(%esi),%esi
    thread_exit(0);
801061b8:	83 ec 0c             	sub    $0xc,%esp
801061bb:	6a 00                	push   $0x0
801061bd:	e8 5e 20 00 00       	call   80108220 <thread_exit>
801061c2:	83 c4 10             	add    $0x10,%esp
801061c5:	e9 6e fe ff ff       	jmp    80106038 <trap+0xc8>
801061ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && (myproc()->killed || myproc()->exited) && (tf->cs&3) == DPL_USER)
801061d0:	e8 bb d6 ff ff       	call   80103890 <myproc>
801061d5:	8b 40 18             	mov    0x18(%eax),%eax
801061d8:	85 c0                	test   %eax,%eax
801061da:	0f 85 89 fe ff ff    	jne    80106069 <trap+0xf9>
801061e0:	e9 91 fe ff ff       	jmp    80106076 <trap+0x106>
801061e5:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && (myproc()->killed || myproc()->exited) && (tf->cs&3) == DPL_USER)
801061e8:	e8 a3 d6 ff ff       	call   80103890 <myproc>
801061ed:	8b 48 18             	mov    0x18(%eax),%ecx
801061f0:	85 c9                	test   %ecx,%ecx
801061f2:	0f 85 2f fe ff ff    	jne    80106027 <trap+0xb7>
801061f8:	e9 3b fe ff ff       	jmp    80106038 <trap+0xc8>
801061fd:	8d 76 00             	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106200:	83 ec 0c             	sub    $0xc,%esp
80106203:	68 a0 80 11 80       	push   $0x801180a0
80106208:	e8 f3 e5 ff ff       	call   80104800 <acquire>
      wakeup(&ticks);
8010620d:	c7 04 24 e0 88 11 80 	movl   $0x801188e0,(%esp)
      ticks++;
80106214:	83 05 e0 88 11 80 01 	addl   $0x1,0x801188e0
      wakeup(&ticks);
8010621b:	e8 40 df ff ff       	call   80104160 <wakeup>
      release(&tickslock);
80106220:	c7 04 24 a0 80 11 80 	movl   $0x801180a0,(%esp)
80106227:	e8 94 e6 ff ff       	call   801048c0 <release>
8010622c:	83 c4 10             	add    $0x10,%esp
8010622f:	e9 c9 fe ff ff       	jmp    801060fd <trap+0x18d>
80106234:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106237:	e8 34 d6 ff ff       	call   80103870 <cpuid>
8010623c:	83 ec 0c             	sub    $0xc,%esp
8010623f:	56                   	push   %esi
80106240:	53                   	push   %ebx
80106241:	50                   	push   %eax
80106242:	ff 77 30             	pushl  0x30(%edi)
80106245:	68 00 8c 10 80       	push   $0x80108c00
8010624a:	e8 01 a4 ff ff       	call   80100650 <cprintf>
      panic("trap");
8010624f:	83 c4 14             	add    $0x14,%esp
80106252:	68 d6 8b 10 80       	push   $0x80108bd6
80106257:	e8 24 a1 ff ff       	call   80100380 <panic>
8010625c:	66 90                	xchg   %ax,%ax
8010625e:	66 90                	xchg   %ax,%ax

80106260 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106260:	a1 dc b5 10 80       	mov    0x8010b5dc,%eax
{
80106265:	55                   	push   %ebp
80106266:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106268:	85 c0                	test   %eax,%eax
8010626a:	74 1c                	je     80106288 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010626c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106271:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106272:	a8 01                	test   $0x1,%al
80106274:	74 12                	je     80106288 <uartgetc+0x28>
80106276:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010627b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010627c:	0f b6 c0             	movzbl %al,%eax
}
8010627f:	5d                   	pop    %ebp
80106280:	c3                   	ret    
80106281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010628d:	5d                   	pop    %ebp
8010628e:	c3                   	ret    
8010628f:	90                   	nop

80106290 <uartputc.part.0>:
uartputc(int c)
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	57                   	push   %edi
80106294:	56                   	push   %esi
80106295:	53                   	push   %ebx
80106296:	89 c7                	mov    %eax,%edi
80106298:	bb 80 00 00 00       	mov    $0x80,%ebx
8010629d:	be fd 03 00 00       	mov    $0x3fd,%esi
801062a2:	83 ec 0c             	sub    $0xc,%esp
801062a5:	eb 1b                	jmp    801062c2 <uartputc.part.0+0x32>
801062a7:	89 f6                	mov    %esi,%esi
801062a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801062b0:	83 ec 0c             	sub    $0xc,%esp
801062b3:	6a 0a                	push   $0xa
801062b5:	e8 96 c5 ff ff       	call   80102850 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062ba:	83 c4 10             	add    $0x10,%esp
801062bd:	83 eb 01             	sub    $0x1,%ebx
801062c0:	74 07                	je     801062c9 <uartputc.part.0+0x39>
801062c2:	89 f2                	mov    %esi,%edx
801062c4:	ec                   	in     (%dx),%al
801062c5:	a8 20                	test   $0x20,%al
801062c7:	74 e7                	je     801062b0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062c9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ce:	89 f8                	mov    %edi,%eax
801062d0:	ee                   	out    %al,(%dx)
}
801062d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062d4:	5b                   	pop    %ebx
801062d5:	5e                   	pop    %esi
801062d6:	5f                   	pop    %edi
801062d7:	5d                   	pop    %ebp
801062d8:	c3                   	ret    
801062d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062e0 <uartinit>:
{
801062e0:	55                   	push   %ebp
801062e1:	31 c9                	xor    %ecx,%ecx
801062e3:	89 c8                	mov    %ecx,%eax
801062e5:	89 e5                	mov    %esp,%ebp
801062e7:	57                   	push   %edi
801062e8:	56                   	push   %esi
801062e9:	53                   	push   %ebx
801062ea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801062ef:	89 da                	mov    %ebx,%edx
801062f1:	83 ec 0c             	sub    $0xc,%esp
801062f4:	ee                   	out    %al,(%dx)
801062f5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801062fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062ff:	89 fa                	mov    %edi,%edx
80106301:	ee                   	out    %al,(%dx)
80106302:	b8 0c 00 00 00       	mov    $0xc,%eax
80106307:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010630c:	ee                   	out    %al,(%dx)
8010630d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106312:	89 c8                	mov    %ecx,%eax
80106314:	89 f2                	mov    %esi,%edx
80106316:	ee                   	out    %al,(%dx)
80106317:	b8 03 00 00 00       	mov    $0x3,%eax
8010631c:	89 fa                	mov    %edi,%edx
8010631e:	ee                   	out    %al,(%dx)
8010631f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106324:	89 c8                	mov    %ecx,%eax
80106326:	ee                   	out    %al,(%dx)
80106327:	b8 01 00 00 00       	mov    $0x1,%eax
8010632c:	89 f2                	mov    %esi,%edx
8010632e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010632f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106334:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106335:	3c ff                	cmp    $0xff,%al
80106337:	74 5a                	je     80106393 <uartinit+0xb3>
  uart = 1;
80106339:	c7 05 dc b5 10 80 01 	movl   $0x1,0x8010b5dc
80106340:	00 00 00 
80106343:	89 da                	mov    %ebx,%edx
80106345:	ec                   	in     (%dx),%al
80106346:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010634b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010634c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010634f:	bb f8 8c 10 80       	mov    $0x80108cf8,%ebx
  ioapicenable(IRQ_COM1, 0);
80106354:	6a 00                	push   $0x0
80106356:	6a 04                	push   $0x4
80106358:	e8 53 c0 ff ff       	call   801023b0 <ioapicenable>
8010635d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106360:	b8 78 00 00 00       	mov    $0x78,%eax
80106365:	eb 13                	jmp    8010637a <uartinit+0x9a>
80106367:	89 f6                	mov    %esi,%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106370:	83 c3 01             	add    $0x1,%ebx
80106373:	0f be 03             	movsbl (%ebx),%eax
80106376:	84 c0                	test   %al,%al
80106378:	74 19                	je     80106393 <uartinit+0xb3>
  if(!uart)
8010637a:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
80106380:	85 d2                	test   %edx,%edx
80106382:	74 ec                	je     80106370 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106384:	83 c3 01             	add    $0x1,%ebx
80106387:	e8 04 ff ff ff       	call   80106290 <uartputc.part.0>
8010638c:	0f be 03             	movsbl (%ebx),%eax
8010638f:	84 c0                	test   %al,%al
80106391:	75 e7                	jne    8010637a <uartinit+0x9a>
}
80106393:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106396:	5b                   	pop    %ebx
80106397:	5e                   	pop    %esi
80106398:	5f                   	pop    %edi
80106399:	5d                   	pop    %ebp
8010639a:	c3                   	ret    
8010639b:	90                   	nop
8010639c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063a0 <uartputc>:
  if(!uart)
801063a0:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
{
801063a6:	55                   	push   %ebp
801063a7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801063a9:	85 d2                	test   %edx,%edx
{
801063ab:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063ae:	74 10                	je     801063c0 <uartputc+0x20>
}
801063b0:	5d                   	pop    %ebp
801063b1:	e9 da fe ff ff       	jmp    80106290 <uartputc.part.0>
801063b6:	8d 76 00             	lea    0x0(%esi),%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801063c0:	5d                   	pop    %ebp
801063c1:	c3                   	ret    
801063c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063d0 <uartintr>:

void
uartintr(void)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063d6:	68 60 62 10 80       	push   $0x80106260
801063db:	e8 20 a4 ff ff       	call   80100800 <consoleintr>
}
801063e0:	83 c4 10             	add    $0x10,%esp
801063e3:	c9                   	leave  
801063e4:	c3                   	ret    

801063e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801063e5:	6a 00                	push   $0x0
  pushl $0
801063e7:	6a 00                	push   $0x0
  jmp alltraps
801063e9:	e9 a9 fa ff ff       	jmp    80105e97 <alltraps>

801063ee <vector1>:
.globl vector1
vector1:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $1
801063f0:	6a 01                	push   $0x1
  jmp alltraps
801063f2:	e9 a0 fa ff ff       	jmp    80105e97 <alltraps>

801063f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $2
801063f9:	6a 02                	push   $0x2
  jmp alltraps
801063fb:	e9 97 fa ff ff       	jmp    80105e97 <alltraps>

80106400 <vector3>:
.globl vector3
vector3:
  pushl $0
80106400:	6a 00                	push   $0x0
  pushl $3
80106402:	6a 03                	push   $0x3
  jmp alltraps
80106404:	e9 8e fa ff ff       	jmp    80105e97 <alltraps>

80106409 <vector4>:
.globl vector4
vector4:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $4
8010640b:	6a 04                	push   $0x4
  jmp alltraps
8010640d:	e9 85 fa ff ff       	jmp    80105e97 <alltraps>

80106412 <vector5>:
.globl vector5
vector5:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $5
80106414:	6a 05                	push   $0x5
  jmp alltraps
80106416:	e9 7c fa ff ff       	jmp    80105e97 <alltraps>

8010641b <vector6>:
.globl vector6
vector6:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $6
8010641d:	6a 06                	push   $0x6
  jmp alltraps
8010641f:	e9 73 fa ff ff       	jmp    80105e97 <alltraps>

80106424 <vector7>:
.globl vector7
vector7:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $7
80106426:	6a 07                	push   $0x7
  jmp alltraps
80106428:	e9 6a fa ff ff       	jmp    80105e97 <alltraps>

8010642d <vector8>:
.globl vector8
vector8:
  pushl $8
8010642d:	6a 08                	push   $0x8
  jmp alltraps
8010642f:	e9 63 fa ff ff       	jmp    80105e97 <alltraps>

80106434 <vector9>:
.globl vector9
vector9:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $9
80106436:	6a 09                	push   $0x9
  jmp alltraps
80106438:	e9 5a fa ff ff       	jmp    80105e97 <alltraps>

8010643d <vector10>:
.globl vector10
vector10:
  pushl $10
8010643d:	6a 0a                	push   $0xa
  jmp alltraps
8010643f:	e9 53 fa ff ff       	jmp    80105e97 <alltraps>

80106444 <vector11>:
.globl vector11
vector11:
  pushl $11
80106444:	6a 0b                	push   $0xb
  jmp alltraps
80106446:	e9 4c fa ff ff       	jmp    80105e97 <alltraps>

8010644b <vector12>:
.globl vector12
vector12:
  pushl $12
8010644b:	6a 0c                	push   $0xc
  jmp alltraps
8010644d:	e9 45 fa ff ff       	jmp    80105e97 <alltraps>

80106452 <vector13>:
.globl vector13
vector13:
  pushl $13
80106452:	6a 0d                	push   $0xd
  jmp alltraps
80106454:	e9 3e fa ff ff       	jmp    80105e97 <alltraps>

80106459 <vector14>:
.globl vector14
vector14:
  pushl $14
80106459:	6a 0e                	push   $0xe
  jmp alltraps
8010645b:	e9 37 fa ff ff       	jmp    80105e97 <alltraps>

80106460 <vector15>:
.globl vector15
vector15:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $15
80106462:	6a 0f                	push   $0xf
  jmp alltraps
80106464:	e9 2e fa ff ff       	jmp    80105e97 <alltraps>

80106469 <vector16>:
.globl vector16
vector16:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $16
8010646b:	6a 10                	push   $0x10
  jmp alltraps
8010646d:	e9 25 fa ff ff       	jmp    80105e97 <alltraps>

80106472 <vector17>:
.globl vector17
vector17:
  pushl $17
80106472:	6a 11                	push   $0x11
  jmp alltraps
80106474:	e9 1e fa ff ff       	jmp    80105e97 <alltraps>

80106479 <vector18>:
.globl vector18
vector18:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $18
8010647b:	6a 12                	push   $0x12
  jmp alltraps
8010647d:	e9 15 fa ff ff       	jmp    80105e97 <alltraps>

80106482 <vector19>:
.globl vector19
vector19:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $19
80106484:	6a 13                	push   $0x13
  jmp alltraps
80106486:	e9 0c fa ff ff       	jmp    80105e97 <alltraps>

8010648b <vector20>:
.globl vector20
vector20:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $20
8010648d:	6a 14                	push   $0x14
  jmp alltraps
8010648f:	e9 03 fa ff ff       	jmp    80105e97 <alltraps>

80106494 <vector21>:
.globl vector21
vector21:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $21
80106496:	6a 15                	push   $0x15
  jmp alltraps
80106498:	e9 fa f9 ff ff       	jmp    80105e97 <alltraps>

8010649d <vector22>:
.globl vector22
vector22:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $22
8010649f:	6a 16                	push   $0x16
  jmp alltraps
801064a1:	e9 f1 f9 ff ff       	jmp    80105e97 <alltraps>

801064a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $23
801064a8:	6a 17                	push   $0x17
  jmp alltraps
801064aa:	e9 e8 f9 ff ff       	jmp    80105e97 <alltraps>

801064af <vector24>:
.globl vector24
vector24:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $24
801064b1:	6a 18                	push   $0x18
  jmp alltraps
801064b3:	e9 df f9 ff ff       	jmp    80105e97 <alltraps>

801064b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $25
801064ba:	6a 19                	push   $0x19
  jmp alltraps
801064bc:	e9 d6 f9 ff ff       	jmp    80105e97 <alltraps>

801064c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $26
801064c3:	6a 1a                	push   $0x1a
  jmp alltraps
801064c5:	e9 cd f9 ff ff       	jmp    80105e97 <alltraps>

801064ca <vector27>:
.globl vector27
vector27:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $27
801064cc:	6a 1b                	push   $0x1b
  jmp alltraps
801064ce:	e9 c4 f9 ff ff       	jmp    80105e97 <alltraps>

801064d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $28
801064d5:	6a 1c                	push   $0x1c
  jmp alltraps
801064d7:	e9 bb f9 ff ff       	jmp    80105e97 <alltraps>

801064dc <vector29>:
.globl vector29
vector29:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $29
801064de:	6a 1d                	push   $0x1d
  jmp alltraps
801064e0:	e9 b2 f9 ff ff       	jmp    80105e97 <alltraps>

801064e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $30
801064e7:	6a 1e                	push   $0x1e
  jmp alltraps
801064e9:	e9 a9 f9 ff ff       	jmp    80105e97 <alltraps>

801064ee <vector31>:
.globl vector31
vector31:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $31
801064f0:	6a 1f                	push   $0x1f
  jmp alltraps
801064f2:	e9 a0 f9 ff ff       	jmp    80105e97 <alltraps>

801064f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $32
801064f9:	6a 20                	push   $0x20
  jmp alltraps
801064fb:	e9 97 f9 ff ff       	jmp    80105e97 <alltraps>

80106500 <vector33>:
.globl vector33
vector33:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $33
80106502:	6a 21                	push   $0x21
  jmp alltraps
80106504:	e9 8e f9 ff ff       	jmp    80105e97 <alltraps>

80106509 <vector34>:
.globl vector34
vector34:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $34
8010650b:	6a 22                	push   $0x22
  jmp alltraps
8010650d:	e9 85 f9 ff ff       	jmp    80105e97 <alltraps>

80106512 <vector35>:
.globl vector35
vector35:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $35
80106514:	6a 23                	push   $0x23
  jmp alltraps
80106516:	e9 7c f9 ff ff       	jmp    80105e97 <alltraps>

8010651b <vector36>:
.globl vector36
vector36:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $36
8010651d:	6a 24                	push   $0x24
  jmp alltraps
8010651f:	e9 73 f9 ff ff       	jmp    80105e97 <alltraps>

80106524 <vector37>:
.globl vector37
vector37:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $37
80106526:	6a 25                	push   $0x25
  jmp alltraps
80106528:	e9 6a f9 ff ff       	jmp    80105e97 <alltraps>

8010652d <vector38>:
.globl vector38
vector38:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $38
8010652f:	6a 26                	push   $0x26
  jmp alltraps
80106531:	e9 61 f9 ff ff       	jmp    80105e97 <alltraps>

80106536 <vector39>:
.globl vector39
vector39:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $39
80106538:	6a 27                	push   $0x27
  jmp alltraps
8010653a:	e9 58 f9 ff ff       	jmp    80105e97 <alltraps>

8010653f <vector40>:
.globl vector40
vector40:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $40
80106541:	6a 28                	push   $0x28
  jmp alltraps
80106543:	e9 4f f9 ff ff       	jmp    80105e97 <alltraps>

80106548 <vector41>:
.globl vector41
vector41:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $41
8010654a:	6a 29                	push   $0x29
  jmp alltraps
8010654c:	e9 46 f9 ff ff       	jmp    80105e97 <alltraps>

80106551 <vector42>:
.globl vector42
vector42:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $42
80106553:	6a 2a                	push   $0x2a
  jmp alltraps
80106555:	e9 3d f9 ff ff       	jmp    80105e97 <alltraps>

8010655a <vector43>:
.globl vector43
vector43:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $43
8010655c:	6a 2b                	push   $0x2b
  jmp alltraps
8010655e:	e9 34 f9 ff ff       	jmp    80105e97 <alltraps>

80106563 <vector44>:
.globl vector44
vector44:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $44
80106565:	6a 2c                	push   $0x2c
  jmp alltraps
80106567:	e9 2b f9 ff ff       	jmp    80105e97 <alltraps>

8010656c <vector45>:
.globl vector45
vector45:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $45
8010656e:	6a 2d                	push   $0x2d
  jmp alltraps
80106570:	e9 22 f9 ff ff       	jmp    80105e97 <alltraps>

80106575 <vector46>:
.globl vector46
vector46:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $46
80106577:	6a 2e                	push   $0x2e
  jmp alltraps
80106579:	e9 19 f9 ff ff       	jmp    80105e97 <alltraps>

8010657e <vector47>:
.globl vector47
vector47:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $47
80106580:	6a 2f                	push   $0x2f
  jmp alltraps
80106582:	e9 10 f9 ff ff       	jmp    80105e97 <alltraps>

80106587 <vector48>:
.globl vector48
vector48:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $48
80106589:	6a 30                	push   $0x30
  jmp alltraps
8010658b:	e9 07 f9 ff ff       	jmp    80105e97 <alltraps>

80106590 <vector49>:
.globl vector49
vector49:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $49
80106592:	6a 31                	push   $0x31
  jmp alltraps
80106594:	e9 fe f8 ff ff       	jmp    80105e97 <alltraps>

80106599 <vector50>:
.globl vector50
vector50:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $50
8010659b:	6a 32                	push   $0x32
  jmp alltraps
8010659d:	e9 f5 f8 ff ff       	jmp    80105e97 <alltraps>

801065a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $51
801065a4:	6a 33                	push   $0x33
  jmp alltraps
801065a6:	e9 ec f8 ff ff       	jmp    80105e97 <alltraps>

801065ab <vector52>:
.globl vector52
vector52:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $52
801065ad:	6a 34                	push   $0x34
  jmp alltraps
801065af:	e9 e3 f8 ff ff       	jmp    80105e97 <alltraps>

801065b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $53
801065b6:	6a 35                	push   $0x35
  jmp alltraps
801065b8:	e9 da f8 ff ff       	jmp    80105e97 <alltraps>

801065bd <vector54>:
.globl vector54
vector54:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $54
801065bf:	6a 36                	push   $0x36
  jmp alltraps
801065c1:	e9 d1 f8 ff ff       	jmp    80105e97 <alltraps>

801065c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $55
801065c8:	6a 37                	push   $0x37
  jmp alltraps
801065ca:	e9 c8 f8 ff ff       	jmp    80105e97 <alltraps>

801065cf <vector56>:
.globl vector56
vector56:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $56
801065d1:	6a 38                	push   $0x38
  jmp alltraps
801065d3:	e9 bf f8 ff ff       	jmp    80105e97 <alltraps>

801065d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $57
801065da:	6a 39                	push   $0x39
  jmp alltraps
801065dc:	e9 b6 f8 ff ff       	jmp    80105e97 <alltraps>

801065e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $58
801065e3:	6a 3a                	push   $0x3a
  jmp alltraps
801065e5:	e9 ad f8 ff ff       	jmp    80105e97 <alltraps>

801065ea <vector59>:
.globl vector59
vector59:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $59
801065ec:	6a 3b                	push   $0x3b
  jmp alltraps
801065ee:	e9 a4 f8 ff ff       	jmp    80105e97 <alltraps>

801065f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $60
801065f5:	6a 3c                	push   $0x3c
  jmp alltraps
801065f7:	e9 9b f8 ff ff       	jmp    80105e97 <alltraps>

801065fc <vector61>:
.globl vector61
vector61:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $61
801065fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106600:	e9 92 f8 ff ff       	jmp    80105e97 <alltraps>

80106605 <vector62>:
.globl vector62
vector62:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $62
80106607:	6a 3e                	push   $0x3e
  jmp alltraps
80106609:	e9 89 f8 ff ff       	jmp    80105e97 <alltraps>

8010660e <vector63>:
.globl vector63
vector63:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $63
80106610:	6a 3f                	push   $0x3f
  jmp alltraps
80106612:	e9 80 f8 ff ff       	jmp    80105e97 <alltraps>

80106617 <vector64>:
.globl vector64
vector64:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $64
80106619:	6a 40                	push   $0x40
  jmp alltraps
8010661b:	e9 77 f8 ff ff       	jmp    80105e97 <alltraps>

80106620 <vector65>:
.globl vector65
vector65:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $65
80106622:	6a 41                	push   $0x41
  jmp alltraps
80106624:	e9 6e f8 ff ff       	jmp    80105e97 <alltraps>

80106629 <vector66>:
.globl vector66
vector66:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $66
8010662b:	6a 42                	push   $0x42
  jmp alltraps
8010662d:	e9 65 f8 ff ff       	jmp    80105e97 <alltraps>

80106632 <vector67>:
.globl vector67
vector67:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $67
80106634:	6a 43                	push   $0x43
  jmp alltraps
80106636:	e9 5c f8 ff ff       	jmp    80105e97 <alltraps>

8010663b <vector68>:
.globl vector68
vector68:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $68
8010663d:	6a 44                	push   $0x44
  jmp alltraps
8010663f:	e9 53 f8 ff ff       	jmp    80105e97 <alltraps>

80106644 <vector69>:
.globl vector69
vector69:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $69
80106646:	6a 45                	push   $0x45
  jmp alltraps
80106648:	e9 4a f8 ff ff       	jmp    80105e97 <alltraps>

8010664d <vector70>:
.globl vector70
vector70:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $70
8010664f:	6a 46                	push   $0x46
  jmp alltraps
80106651:	e9 41 f8 ff ff       	jmp    80105e97 <alltraps>

80106656 <vector71>:
.globl vector71
vector71:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $71
80106658:	6a 47                	push   $0x47
  jmp alltraps
8010665a:	e9 38 f8 ff ff       	jmp    80105e97 <alltraps>

8010665f <vector72>:
.globl vector72
vector72:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $72
80106661:	6a 48                	push   $0x48
  jmp alltraps
80106663:	e9 2f f8 ff ff       	jmp    80105e97 <alltraps>

80106668 <vector73>:
.globl vector73
vector73:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $73
8010666a:	6a 49                	push   $0x49
  jmp alltraps
8010666c:	e9 26 f8 ff ff       	jmp    80105e97 <alltraps>

80106671 <vector74>:
.globl vector74
vector74:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $74
80106673:	6a 4a                	push   $0x4a
  jmp alltraps
80106675:	e9 1d f8 ff ff       	jmp    80105e97 <alltraps>

8010667a <vector75>:
.globl vector75
vector75:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $75
8010667c:	6a 4b                	push   $0x4b
  jmp alltraps
8010667e:	e9 14 f8 ff ff       	jmp    80105e97 <alltraps>

80106683 <vector76>:
.globl vector76
vector76:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $76
80106685:	6a 4c                	push   $0x4c
  jmp alltraps
80106687:	e9 0b f8 ff ff       	jmp    80105e97 <alltraps>

8010668c <vector77>:
.globl vector77
vector77:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $77
8010668e:	6a 4d                	push   $0x4d
  jmp alltraps
80106690:	e9 02 f8 ff ff       	jmp    80105e97 <alltraps>

80106695 <vector78>:
.globl vector78
vector78:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $78
80106697:	6a 4e                	push   $0x4e
  jmp alltraps
80106699:	e9 f9 f7 ff ff       	jmp    80105e97 <alltraps>

8010669e <vector79>:
.globl vector79
vector79:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $79
801066a0:	6a 4f                	push   $0x4f
  jmp alltraps
801066a2:	e9 f0 f7 ff ff       	jmp    80105e97 <alltraps>

801066a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $80
801066a9:	6a 50                	push   $0x50
  jmp alltraps
801066ab:	e9 e7 f7 ff ff       	jmp    80105e97 <alltraps>

801066b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $81
801066b2:	6a 51                	push   $0x51
  jmp alltraps
801066b4:	e9 de f7 ff ff       	jmp    80105e97 <alltraps>

801066b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $82
801066bb:	6a 52                	push   $0x52
  jmp alltraps
801066bd:	e9 d5 f7 ff ff       	jmp    80105e97 <alltraps>

801066c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $83
801066c4:	6a 53                	push   $0x53
  jmp alltraps
801066c6:	e9 cc f7 ff ff       	jmp    80105e97 <alltraps>

801066cb <vector84>:
.globl vector84
vector84:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $84
801066cd:	6a 54                	push   $0x54
  jmp alltraps
801066cf:	e9 c3 f7 ff ff       	jmp    80105e97 <alltraps>

801066d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $85
801066d6:	6a 55                	push   $0x55
  jmp alltraps
801066d8:	e9 ba f7 ff ff       	jmp    80105e97 <alltraps>

801066dd <vector86>:
.globl vector86
vector86:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $86
801066df:	6a 56                	push   $0x56
  jmp alltraps
801066e1:	e9 b1 f7 ff ff       	jmp    80105e97 <alltraps>

801066e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $87
801066e8:	6a 57                	push   $0x57
  jmp alltraps
801066ea:	e9 a8 f7 ff ff       	jmp    80105e97 <alltraps>

801066ef <vector88>:
.globl vector88
vector88:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $88
801066f1:	6a 58                	push   $0x58
  jmp alltraps
801066f3:	e9 9f f7 ff ff       	jmp    80105e97 <alltraps>

801066f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $89
801066fa:	6a 59                	push   $0x59
  jmp alltraps
801066fc:	e9 96 f7 ff ff       	jmp    80105e97 <alltraps>

80106701 <vector90>:
.globl vector90
vector90:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $90
80106703:	6a 5a                	push   $0x5a
  jmp alltraps
80106705:	e9 8d f7 ff ff       	jmp    80105e97 <alltraps>

8010670a <vector91>:
.globl vector91
vector91:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $91
8010670c:	6a 5b                	push   $0x5b
  jmp alltraps
8010670e:	e9 84 f7 ff ff       	jmp    80105e97 <alltraps>

80106713 <vector92>:
.globl vector92
vector92:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $92
80106715:	6a 5c                	push   $0x5c
  jmp alltraps
80106717:	e9 7b f7 ff ff       	jmp    80105e97 <alltraps>

8010671c <vector93>:
.globl vector93
vector93:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $93
8010671e:	6a 5d                	push   $0x5d
  jmp alltraps
80106720:	e9 72 f7 ff ff       	jmp    80105e97 <alltraps>

80106725 <vector94>:
.globl vector94
vector94:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $94
80106727:	6a 5e                	push   $0x5e
  jmp alltraps
80106729:	e9 69 f7 ff ff       	jmp    80105e97 <alltraps>

8010672e <vector95>:
.globl vector95
vector95:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $95
80106730:	6a 5f                	push   $0x5f
  jmp alltraps
80106732:	e9 60 f7 ff ff       	jmp    80105e97 <alltraps>

80106737 <vector96>:
.globl vector96
vector96:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $96
80106739:	6a 60                	push   $0x60
  jmp alltraps
8010673b:	e9 57 f7 ff ff       	jmp    80105e97 <alltraps>

80106740 <vector97>:
.globl vector97
vector97:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $97
80106742:	6a 61                	push   $0x61
  jmp alltraps
80106744:	e9 4e f7 ff ff       	jmp    80105e97 <alltraps>

80106749 <vector98>:
.globl vector98
vector98:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $98
8010674b:	6a 62                	push   $0x62
  jmp alltraps
8010674d:	e9 45 f7 ff ff       	jmp    80105e97 <alltraps>

80106752 <vector99>:
.globl vector99
vector99:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $99
80106754:	6a 63                	push   $0x63
  jmp alltraps
80106756:	e9 3c f7 ff ff       	jmp    80105e97 <alltraps>

8010675b <vector100>:
.globl vector100
vector100:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $100
8010675d:	6a 64                	push   $0x64
  jmp alltraps
8010675f:	e9 33 f7 ff ff       	jmp    80105e97 <alltraps>

80106764 <vector101>:
.globl vector101
vector101:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $101
80106766:	6a 65                	push   $0x65
  jmp alltraps
80106768:	e9 2a f7 ff ff       	jmp    80105e97 <alltraps>

8010676d <vector102>:
.globl vector102
vector102:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $102
8010676f:	6a 66                	push   $0x66
  jmp alltraps
80106771:	e9 21 f7 ff ff       	jmp    80105e97 <alltraps>

80106776 <vector103>:
.globl vector103
vector103:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $103
80106778:	6a 67                	push   $0x67
  jmp alltraps
8010677a:	e9 18 f7 ff ff       	jmp    80105e97 <alltraps>

8010677f <vector104>:
.globl vector104
vector104:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $104
80106781:	6a 68                	push   $0x68
  jmp alltraps
80106783:	e9 0f f7 ff ff       	jmp    80105e97 <alltraps>

80106788 <vector105>:
.globl vector105
vector105:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $105
8010678a:	6a 69                	push   $0x69
  jmp alltraps
8010678c:	e9 06 f7 ff ff       	jmp    80105e97 <alltraps>

80106791 <vector106>:
.globl vector106
vector106:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $106
80106793:	6a 6a                	push   $0x6a
  jmp alltraps
80106795:	e9 fd f6 ff ff       	jmp    80105e97 <alltraps>

8010679a <vector107>:
.globl vector107
vector107:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $107
8010679c:	6a 6b                	push   $0x6b
  jmp alltraps
8010679e:	e9 f4 f6 ff ff       	jmp    80105e97 <alltraps>

801067a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $108
801067a5:	6a 6c                	push   $0x6c
  jmp alltraps
801067a7:	e9 eb f6 ff ff       	jmp    80105e97 <alltraps>

801067ac <vector109>:
.globl vector109
vector109:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $109
801067ae:	6a 6d                	push   $0x6d
  jmp alltraps
801067b0:	e9 e2 f6 ff ff       	jmp    80105e97 <alltraps>

801067b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $110
801067b7:	6a 6e                	push   $0x6e
  jmp alltraps
801067b9:	e9 d9 f6 ff ff       	jmp    80105e97 <alltraps>

801067be <vector111>:
.globl vector111
vector111:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $111
801067c0:	6a 6f                	push   $0x6f
  jmp alltraps
801067c2:	e9 d0 f6 ff ff       	jmp    80105e97 <alltraps>

801067c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $112
801067c9:	6a 70                	push   $0x70
  jmp alltraps
801067cb:	e9 c7 f6 ff ff       	jmp    80105e97 <alltraps>

801067d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $113
801067d2:	6a 71                	push   $0x71
  jmp alltraps
801067d4:	e9 be f6 ff ff       	jmp    80105e97 <alltraps>

801067d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $114
801067db:	6a 72                	push   $0x72
  jmp alltraps
801067dd:	e9 b5 f6 ff ff       	jmp    80105e97 <alltraps>

801067e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $115
801067e4:	6a 73                	push   $0x73
  jmp alltraps
801067e6:	e9 ac f6 ff ff       	jmp    80105e97 <alltraps>

801067eb <vector116>:
.globl vector116
vector116:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $116
801067ed:	6a 74                	push   $0x74
  jmp alltraps
801067ef:	e9 a3 f6 ff ff       	jmp    80105e97 <alltraps>

801067f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $117
801067f6:	6a 75                	push   $0x75
  jmp alltraps
801067f8:	e9 9a f6 ff ff       	jmp    80105e97 <alltraps>

801067fd <vector118>:
.globl vector118
vector118:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $118
801067ff:	6a 76                	push   $0x76
  jmp alltraps
80106801:	e9 91 f6 ff ff       	jmp    80105e97 <alltraps>

80106806 <vector119>:
.globl vector119
vector119:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $119
80106808:	6a 77                	push   $0x77
  jmp alltraps
8010680a:	e9 88 f6 ff ff       	jmp    80105e97 <alltraps>

8010680f <vector120>:
.globl vector120
vector120:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $120
80106811:	6a 78                	push   $0x78
  jmp alltraps
80106813:	e9 7f f6 ff ff       	jmp    80105e97 <alltraps>

80106818 <vector121>:
.globl vector121
vector121:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $121
8010681a:	6a 79                	push   $0x79
  jmp alltraps
8010681c:	e9 76 f6 ff ff       	jmp    80105e97 <alltraps>

80106821 <vector122>:
.globl vector122
vector122:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $122
80106823:	6a 7a                	push   $0x7a
  jmp alltraps
80106825:	e9 6d f6 ff ff       	jmp    80105e97 <alltraps>

8010682a <vector123>:
.globl vector123
vector123:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $123
8010682c:	6a 7b                	push   $0x7b
  jmp alltraps
8010682e:	e9 64 f6 ff ff       	jmp    80105e97 <alltraps>

80106833 <vector124>:
.globl vector124
vector124:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $124
80106835:	6a 7c                	push   $0x7c
  jmp alltraps
80106837:	e9 5b f6 ff ff       	jmp    80105e97 <alltraps>

8010683c <vector125>:
.globl vector125
vector125:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $125
8010683e:	6a 7d                	push   $0x7d
  jmp alltraps
80106840:	e9 52 f6 ff ff       	jmp    80105e97 <alltraps>

80106845 <vector126>:
.globl vector126
vector126:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $126
80106847:	6a 7e                	push   $0x7e
  jmp alltraps
80106849:	e9 49 f6 ff ff       	jmp    80105e97 <alltraps>

8010684e <vector127>:
.globl vector127
vector127:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $127
80106850:	6a 7f                	push   $0x7f
  jmp alltraps
80106852:	e9 40 f6 ff ff       	jmp    80105e97 <alltraps>

80106857 <vector128>:
.globl vector128
vector128:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $128
80106859:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010685e:	e9 34 f6 ff ff       	jmp    80105e97 <alltraps>

80106863 <vector129>:
.globl vector129
vector129:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $129
80106865:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010686a:	e9 28 f6 ff ff       	jmp    80105e97 <alltraps>

8010686f <vector130>:
.globl vector130
vector130:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $130
80106871:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106876:	e9 1c f6 ff ff       	jmp    80105e97 <alltraps>

8010687b <vector131>:
.globl vector131
vector131:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $131
8010687d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106882:	e9 10 f6 ff ff       	jmp    80105e97 <alltraps>

80106887 <vector132>:
.globl vector132
vector132:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $132
80106889:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010688e:	e9 04 f6 ff ff       	jmp    80105e97 <alltraps>

80106893 <vector133>:
.globl vector133
vector133:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $133
80106895:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010689a:	e9 f8 f5 ff ff       	jmp    80105e97 <alltraps>

8010689f <vector134>:
.globl vector134
vector134:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $134
801068a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068a6:	e9 ec f5 ff ff       	jmp    80105e97 <alltraps>

801068ab <vector135>:
.globl vector135
vector135:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $135
801068ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068b2:	e9 e0 f5 ff ff       	jmp    80105e97 <alltraps>

801068b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $136
801068b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068be:	e9 d4 f5 ff ff       	jmp    80105e97 <alltraps>

801068c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $137
801068c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068ca:	e9 c8 f5 ff ff       	jmp    80105e97 <alltraps>

801068cf <vector138>:
.globl vector138
vector138:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $138
801068d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068d6:	e9 bc f5 ff ff       	jmp    80105e97 <alltraps>

801068db <vector139>:
.globl vector139
vector139:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $139
801068dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801068e2:	e9 b0 f5 ff ff       	jmp    80105e97 <alltraps>

801068e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $140
801068e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801068ee:	e9 a4 f5 ff ff       	jmp    80105e97 <alltraps>

801068f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $141
801068f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801068fa:	e9 98 f5 ff ff       	jmp    80105e97 <alltraps>

801068ff <vector142>:
.globl vector142
vector142:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $142
80106901:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106906:	e9 8c f5 ff ff       	jmp    80105e97 <alltraps>

8010690b <vector143>:
.globl vector143
vector143:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $143
8010690d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106912:	e9 80 f5 ff ff       	jmp    80105e97 <alltraps>

80106917 <vector144>:
.globl vector144
vector144:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $144
80106919:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010691e:	e9 74 f5 ff ff       	jmp    80105e97 <alltraps>

80106923 <vector145>:
.globl vector145
vector145:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $145
80106925:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010692a:	e9 68 f5 ff ff       	jmp    80105e97 <alltraps>

8010692f <vector146>:
.globl vector146
vector146:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $146
80106931:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106936:	e9 5c f5 ff ff       	jmp    80105e97 <alltraps>

8010693b <vector147>:
.globl vector147
vector147:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $147
8010693d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106942:	e9 50 f5 ff ff       	jmp    80105e97 <alltraps>

80106947 <vector148>:
.globl vector148
vector148:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $148
80106949:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010694e:	e9 44 f5 ff ff       	jmp    80105e97 <alltraps>

80106953 <vector149>:
.globl vector149
vector149:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $149
80106955:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010695a:	e9 38 f5 ff ff       	jmp    80105e97 <alltraps>

8010695f <vector150>:
.globl vector150
vector150:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $150
80106961:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106966:	e9 2c f5 ff ff       	jmp    80105e97 <alltraps>

8010696b <vector151>:
.globl vector151
vector151:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $151
8010696d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106972:	e9 20 f5 ff ff       	jmp    80105e97 <alltraps>

80106977 <vector152>:
.globl vector152
vector152:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $152
80106979:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010697e:	e9 14 f5 ff ff       	jmp    80105e97 <alltraps>

80106983 <vector153>:
.globl vector153
vector153:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $153
80106985:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010698a:	e9 08 f5 ff ff       	jmp    80105e97 <alltraps>

8010698f <vector154>:
.globl vector154
vector154:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $154
80106991:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106996:	e9 fc f4 ff ff       	jmp    80105e97 <alltraps>

8010699b <vector155>:
.globl vector155
vector155:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $155
8010699d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069a2:	e9 f0 f4 ff ff       	jmp    80105e97 <alltraps>

801069a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $156
801069a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069ae:	e9 e4 f4 ff ff       	jmp    80105e97 <alltraps>

801069b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $157
801069b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069ba:	e9 d8 f4 ff ff       	jmp    80105e97 <alltraps>

801069bf <vector158>:
.globl vector158
vector158:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $158
801069c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069c6:	e9 cc f4 ff ff       	jmp    80105e97 <alltraps>

801069cb <vector159>:
.globl vector159
vector159:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $159
801069cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069d2:	e9 c0 f4 ff ff       	jmp    80105e97 <alltraps>

801069d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $160
801069d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801069de:	e9 b4 f4 ff ff       	jmp    80105e97 <alltraps>

801069e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $161
801069e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801069ea:	e9 a8 f4 ff ff       	jmp    80105e97 <alltraps>

801069ef <vector162>:
.globl vector162
vector162:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $162
801069f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801069f6:	e9 9c f4 ff ff       	jmp    80105e97 <alltraps>

801069fb <vector163>:
.globl vector163
vector163:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $163
801069fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a02:	e9 90 f4 ff ff       	jmp    80105e97 <alltraps>

80106a07 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $164
80106a09:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a0e:	e9 84 f4 ff ff       	jmp    80105e97 <alltraps>

80106a13 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $165
80106a15:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a1a:	e9 78 f4 ff ff       	jmp    80105e97 <alltraps>

80106a1f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $166
80106a21:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a26:	e9 6c f4 ff ff       	jmp    80105e97 <alltraps>

80106a2b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $167
80106a2d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a32:	e9 60 f4 ff ff       	jmp    80105e97 <alltraps>

80106a37 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $168
80106a39:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a3e:	e9 54 f4 ff ff       	jmp    80105e97 <alltraps>

80106a43 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $169
80106a45:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a4a:	e9 48 f4 ff ff       	jmp    80105e97 <alltraps>

80106a4f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $170
80106a51:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a56:	e9 3c f4 ff ff       	jmp    80105e97 <alltraps>

80106a5b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $171
80106a5d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a62:	e9 30 f4 ff ff       	jmp    80105e97 <alltraps>

80106a67 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $172
80106a69:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a6e:	e9 24 f4 ff ff       	jmp    80105e97 <alltraps>

80106a73 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $173
80106a75:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a7a:	e9 18 f4 ff ff       	jmp    80105e97 <alltraps>

80106a7f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $174
80106a81:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a86:	e9 0c f4 ff ff       	jmp    80105e97 <alltraps>

80106a8b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $175
80106a8d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a92:	e9 00 f4 ff ff       	jmp    80105e97 <alltraps>

80106a97 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $176
80106a99:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a9e:	e9 f4 f3 ff ff       	jmp    80105e97 <alltraps>

80106aa3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $177
80106aa5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106aaa:	e9 e8 f3 ff ff       	jmp    80105e97 <alltraps>

80106aaf <vector178>:
.globl vector178
vector178:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $178
80106ab1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ab6:	e9 dc f3 ff ff       	jmp    80105e97 <alltraps>

80106abb <vector179>:
.globl vector179
vector179:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $179
80106abd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ac2:	e9 d0 f3 ff ff       	jmp    80105e97 <alltraps>

80106ac7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $180
80106ac9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ace:	e9 c4 f3 ff ff       	jmp    80105e97 <alltraps>

80106ad3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $181
80106ad5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106ada:	e9 b8 f3 ff ff       	jmp    80105e97 <alltraps>

80106adf <vector182>:
.globl vector182
vector182:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $182
80106ae1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ae6:	e9 ac f3 ff ff       	jmp    80105e97 <alltraps>

80106aeb <vector183>:
.globl vector183
vector183:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $183
80106aed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106af2:	e9 a0 f3 ff ff       	jmp    80105e97 <alltraps>

80106af7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $184
80106af9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106afe:	e9 94 f3 ff ff       	jmp    80105e97 <alltraps>

80106b03 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $185
80106b05:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b0a:	e9 88 f3 ff ff       	jmp    80105e97 <alltraps>

80106b0f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $186
80106b11:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b16:	e9 7c f3 ff ff       	jmp    80105e97 <alltraps>

80106b1b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $187
80106b1d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b22:	e9 70 f3 ff ff       	jmp    80105e97 <alltraps>

80106b27 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $188
80106b29:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b2e:	e9 64 f3 ff ff       	jmp    80105e97 <alltraps>

80106b33 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $189
80106b35:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b3a:	e9 58 f3 ff ff       	jmp    80105e97 <alltraps>

80106b3f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $190
80106b41:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b46:	e9 4c f3 ff ff       	jmp    80105e97 <alltraps>

80106b4b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $191
80106b4d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b52:	e9 40 f3 ff ff       	jmp    80105e97 <alltraps>

80106b57 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $192
80106b59:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b5e:	e9 34 f3 ff ff       	jmp    80105e97 <alltraps>

80106b63 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $193
80106b65:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b6a:	e9 28 f3 ff ff       	jmp    80105e97 <alltraps>

80106b6f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $194
80106b71:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b76:	e9 1c f3 ff ff       	jmp    80105e97 <alltraps>

80106b7b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $195
80106b7d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b82:	e9 10 f3 ff ff       	jmp    80105e97 <alltraps>

80106b87 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $196
80106b89:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b8e:	e9 04 f3 ff ff       	jmp    80105e97 <alltraps>

80106b93 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $197
80106b95:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b9a:	e9 f8 f2 ff ff       	jmp    80105e97 <alltraps>

80106b9f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $198
80106ba1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106ba6:	e9 ec f2 ff ff       	jmp    80105e97 <alltraps>

80106bab <vector199>:
.globl vector199
vector199:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $199
80106bad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bb2:	e9 e0 f2 ff ff       	jmp    80105e97 <alltraps>

80106bb7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $200
80106bb9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bbe:	e9 d4 f2 ff ff       	jmp    80105e97 <alltraps>

80106bc3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $201
80106bc5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106bca:	e9 c8 f2 ff ff       	jmp    80105e97 <alltraps>

80106bcf <vector202>:
.globl vector202
vector202:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $202
80106bd1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106bd6:	e9 bc f2 ff ff       	jmp    80105e97 <alltraps>

80106bdb <vector203>:
.globl vector203
vector203:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $203
80106bdd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106be2:	e9 b0 f2 ff ff       	jmp    80105e97 <alltraps>

80106be7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $204
80106be9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106bee:	e9 a4 f2 ff ff       	jmp    80105e97 <alltraps>

80106bf3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $205
80106bf5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106bfa:	e9 98 f2 ff ff       	jmp    80105e97 <alltraps>

80106bff <vector206>:
.globl vector206
vector206:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $206
80106c01:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c06:	e9 8c f2 ff ff       	jmp    80105e97 <alltraps>

80106c0b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $207
80106c0d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c12:	e9 80 f2 ff ff       	jmp    80105e97 <alltraps>

80106c17 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $208
80106c19:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c1e:	e9 74 f2 ff ff       	jmp    80105e97 <alltraps>

80106c23 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $209
80106c25:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c2a:	e9 68 f2 ff ff       	jmp    80105e97 <alltraps>

80106c2f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $210
80106c31:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c36:	e9 5c f2 ff ff       	jmp    80105e97 <alltraps>

80106c3b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $211
80106c3d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c42:	e9 50 f2 ff ff       	jmp    80105e97 <alltraps>

80106c47 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $212
80106c49:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c4e:	e9 44 f2 ff ff       	jmp    80105e97 <alltraps>

80106c53 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $213
80106c55:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c5a:	e9 38 f2 ff ff       	jmp    80105e97 <alltraps>

80106c5f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $214
80106c61:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c66:	e9 2c f2 ff ff       	jmp    80105e97 <alltraps>

80106c6b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $215
80106c6d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c72:	e9 20 f2 ff ff       	jmp    80105e97 <alltraps>

80106c77 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $216
80106c79:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c7e:	e9 14 f2 ff ff       	jmp    80105e97 <alltraps>

80106c83 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $217
80106c85:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c8a:	e9 08 f2 ff ff       	jmp    80105e97 <alltraps>

80106c8f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $218
80106c91:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c96:	e9 fc f1 ff ff       	jmp    80105e97 <alltraps>

80106c9b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $219
80106c9d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ca2:	e9 f0 f1 ff ff       	jmp    80105e97 <alltraps>

80106ca7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $220
80106ca9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cae:	e9 e4 f1 ff ff       	jmp    80105e97 <alltraps>

80106cb3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $221
80106cb5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cba:	e9 d8 f1 ff ff       	jmp    80105e97 <alltraps>

80106cbf <vector222>:
.globl vector222
vector222:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $222
80106cc1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106cc6:	e9 cc f1 ff ff       	jmp    80105e97 <alltraps>

80106ccb <vector223>:
.globl vector223
vector223:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $223
80106ccd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106cd2:	e9 c0 f1 ff ff       	jmp    80105e97 <alltraps>

80106cd7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $224
80106cd9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106cde:	e9 b4 f1 ff ff       	jmp    80105e97 <alltraps>

80106ce3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $225
80106ce5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106cea:	e9 a8 f1 ff ff       	jmp    80105e97 <alltraps>

80106cef <vector226>:
.globl vector226
vector226:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $226
80106cf1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106cf6:	e9 9c f1 ff ff       	jmp    80105e97 <alltraps>

80106cfb <vector227>:
.globl vector227
vector227:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $227
80106cfd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d02:	e9 90 f1 ff ff       	jmp    80105e97 <alltraps>

80106d07 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $228
80106d09:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d0e:	e9 84 f1 ff ff       	jmp    80105e97 <alltraps>

80106d13 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $229
80106d15:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d1a:	e9 78 f1 ff ff       	jmp    80105e97 <alltraps>

80106d1f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $230
80106d21:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d26:	e9 6c f1 ff ff       	jmp    80105e97 <alltraps>

80106d2b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $231
80106d2d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d32:	e9 60 f1 ff ff       	jmp    80105e97 <alltraps>

80106d37 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $232
80106d39:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d3e:	e9 54 f1 ff ff       	jmp    80105e97 <alltraps>

80106d43 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $233
80106d45:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d4a:	e9 48 f1 ff ff       	jmp    80105e97 <alltraps>

80106d4f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $234
80106d51:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d56:	e9 3c f1 ff ff       	jmp    80105e97 <alltraps>

80106d5b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $235
80106d5d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d62:	e9 30 f1 ff ff       	jmp    80105e97 <alltraps>

80106d67 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $236
80106d69:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d6e:	e9 24 f1 ff ff       	jmp    80105e97 <alltraps>

80106d73 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $237
80106d75:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d7a:	e9 18 f1 ff ff       	jmp    80105e97 <alltraps>

80106d7f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $238
80106d81:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d86:	e9 0c f1 ff ff       	jmp    80105e97 <alltraps>

80106d8b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $239
80106d8d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d92:	e9 00 f1 ff ff       	jmp    80105e97 <alltraps>

80106d97 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $240
80106d99:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d9e:	e9 f4 f0 ff ff       	jmp    80105e97 <alltraps>

80106da3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $241
80106da5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106daa:	e9 e8 f0 ff ff       	jmp    80105e97 <alltraps>

80106daf <vector242>:
.globl vector242
vector242:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $242
80106db1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106db6:	e9 dc f0 ff ff       	jmp    80105e97 <alltraps>

80106dbb <vector243>:
.globl vector243
vector243:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $243
80106dbd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106dc2:	e9 d0 f0 ff ff       	jmp    80105e97 <alltraps>

80106dc7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $244
80106dc9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106dce:	e9 c4 f0 ff ff       	jmp    80105e97 <alltraps>

80106dd3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $245
80106dd5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dda:	e9 b8 f0 ff ff       	jmp    80105e97 <alltraps>

80106ddf <vector246>:
.globl vector246
vector246:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $246
80106de1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106de6:	e9 ac f0 ff ff       	jmp    80105e97 <alltraps>

80106deb <vector247>:
.globl vector247
vector247:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $247
80106ded:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106df2:	e9 a0 f0 ff ff       	jmp    80105e97 <alltraps>

80106df7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $248
80106df9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106dfe:	e9 94 f0 ff ff       	jmp    80105e97 <alltraps>

80106e03 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $249
80106e05:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e0a:	e9 88 f0 ff ff       	jmp    80105e97 <alltraps>

80106e0f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $250
80106e11:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e16:	e9 7c f0 ff ff       	jmp    80105e97 <alltraps>

80106e1b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $251
80106e1d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e22:	e9 70 f0 ff ff       	jmp    80105e97 <alltraps>

80106e27 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $252
80106e29:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e2e:	e9 64 f0 ff ff       	jmp    80105e97 <alltraps>

80106e33 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $253
80106e35:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e3a:	e9 58 f0 ff ff       	jmp    80105e97 <alltraps>

80106e3f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $254
80106e41:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e46:	e9 4c f0 ff ff       	jmp    80105e97 <alltraps>

80106e4b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $255
80106e4d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e52:	e9 40 f0 ff ff       	jmp    80105e97 <alltraps>
80106e57:	66 90                	xchg   %ax,%ax
80106e59:	66 90                	xchg   %ax,%ax
80106e5b:	66 90                	xchg   %ax,%ax
80106e5d:	66 90                	xchg   %ax,%ax
80106e5f:	90                   	nop

80106e60 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	57                   	push   %edi
80106e64:	56                   	push   %esi
80106e65:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e66:	89 d3                	mov    %edx,%ebx
{
80106e68:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106e6a:	c1 eb 16             	shr    $0x16,%ebx
80106e6d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106e70:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e73:	8b 06                	mov    (%esi),%eax
80106e75:	a8 01                	test   $0x1,%al
80106e77:	74 27                	je     80106ea0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e79:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e7e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e84:	c1 ef 0a             	shr    $0xa,%edi
}
80106e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e8a:	89 fa                	mov    %edi,%edx
80106e8c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e92:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106e95:	5b                   	pop    %ebx
80106e96:	5e                   	pop    %esi
80106e97:	5f                   	pop    %edi
80106e98:	5d                   	pop    %ebp
80106e99:	c3                   	ret    
80106e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ea0:	85 c9                	test   %ecx,%ecx
80106ea2:	74 2c                	je     80106ed0 <walkpgdir+0x70>
80106ea4:	e8 f7 b6 ff ff       	call   801025a0 <kalloc>
80106ea9:	85 c0                	test   %eax,%eax
80106eab:	89 c3                	mov    %eax,%ebx
80106ead:	74 21                	je     80106ed0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106eaf:	83 ec 04             	sub    $0x4,%esp
80106eb2:	68 00 10 00 00       	push   $0x1000
80106eb7:	6a 00                	push   $0x0
80106eb9:	50                   	push   %eax
80106eba:	e8 51 da ff ff       	call   80104910 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ebf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ec5:	83 c4 10             	add    $0x10,%esp
80106ec8:	83 c8 07             	or     $0x7,%eax
80106ecb:	89 06                	mov    %eax,(%esi)
80106ecd:	eb b5                	jmp    80106e84 <walkpgdir+0x24>
80106ecf:	90                   	nop
}
80106ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ed3:	31 c0                	xor    %eax,%eax
}
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
80106eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ee0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ee6:	89 d3                	mov    %edx,%ebx
80106ee8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106eee:	83 ec 1c             	sub    $0x1c,%esp
80106ef1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ef4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ef8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106efb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f00:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f03:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f06:	29 df                	sub    %ebx,%edi
80106f08:	83 c8 01             	or     $0x1,%eax
80106f0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f0e:	eb 15                	jmp    80106f25 <mappages+0x45>
    if(*pte & PTE_P)
80106f10:	f6 00 01             	testb  $0x1,(%eax)
80106f13:	75 45                	jne    80106f5a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106f15:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106f18:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106f1b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f1d:	74 31                	je     80106f50 <mappages+0x70>
      break;
    a += PGSIZE;
80106f1f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f28:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f2d:	89 da                	mov    %ebx,%edx
80106f2f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106f32:	e8 29 ff ff ff       	call   80106e60 <walkpgdir>
80106f37:	85 c0                	test   %eax,%eax
80106f39:	75 d5                	jne    80106f10 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f43:	5b                   	pop    %ebx
80106f44:	5e                   	pop    %esi
80106f45:	5f                   	pop    %edi
80106f46:	5d                   	pop    %ebp
80106f47:	c3                   	ret    
80106f48:	90                   	nop
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f53:	31 c0                	xor    %eax,%eax
}
80106f55:	5b                   	pop    %ebx
80106f56:	5e                   	pop    %esi
80106f57:	5f                   	pop    %edi
80106f58:	5d                   	pop    %ebp
80106f59:	c3                   	ret    
      panic("remap");
80106f5a:	83 ec 0c             	sub    $0xc,%esp
80106f5d:	68 00 8d 10 80       	push   $0x80108d00
80106f62:	e8 19 94 ff ff       	call   80100380 <panic>
80106f67:	89 f6                	mov    %esi,%esi
80106f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f7c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106f7e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f84:	83 ec 1c             	sub    $0x1c,%esp
80106f87:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f8a:	39 d3                	cmp    %edx,%ebx
80106f8c:	73 66                	jae    80106ff4 <deallocuvm.part.0+0x84>
80106f8e:	89 d6                	mov    %edx,%esi
80106f90:	eb 3d                	jmp    80106fcf <deallocuvm.part.0+0x5f>
80106f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106f98:	8b 10                	mov    (%eax),%edx
80106f9a:	f6 c2 01             	test   $0x1,%dl
80106f9d:	74 26                	je     80106fc5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106f9f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106fa5:	74 58                	je     80106fff <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106fa7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106faa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106fb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106fb3:	52                   	push   %edx
80106fb4:	e8 37 b4 ff ff       	call   801023f0 <kfree>
      *pte = 0;
80106fb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fbc:	83 c4 10             	add    $0x10,%esp
80106fbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106fc5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fcb:	39 f3                	cmp    %esi,%ebx
80106fcd:	73 25                	jae    80106ff4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106fcf:	31 c9                	xor    %ecx,%ecx
80106fd1:	89 da                	mov    %ebx,%edx
80106fd3:	89 f8                	mov    %edi,%eax
80106fd5:	e8 86 fe ff ff       	call   80106e60 <walkpgdir>
    if(!pte)
80106fda:	85 c0                	test   %eax,%eax
80106fdc:	75 ba                	jne    80106f98 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106fde:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106fe4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106fea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ff0:	39 f3                	cmp    %esi,%ebx
80106ff2:	72 db                	jb     80106fcf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106ff4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ffa:	5b                   	pop    %ebx
80106ffb:	5e                   	pop    %esi
80106ffc:	5f                   	pop    %edi
80106ffd:	5d                   	pop    %ebp
80106ffe:	c3                   	ret    
        panic("kfree");
80106fff:	83 ec 0c             	sub    $0xc,%esp
80107002:	68 a6 86 10 80       	push   $0x801086a6
80107007:	e8 74 93 ff ff       	call   80100380 <panic>
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107010 <seginit>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107016:	e8 55 c8 ff ff       	call   80103870 <cpuid>
8010701b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  pd[0] = size-1;
80107021:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107026:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010702a:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80107031:	ff 00 00 
80107034:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
8010703b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010703e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80107045:	ff 00 00 
80107048:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
8010704f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107052:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80107059:	ff 00 00 
8010705c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107063:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107066:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
8010706d:	ff 00 00 
80107070:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80107077:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010707a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
8010707f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107083:	c1 e8 10             	shr    $0x10,%eax
80107086:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010708a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010708d:	0f 01 10             	lgdtl  (%eax)
}
80107090:	c9                   	leave  
80107091:	c3                   	ret    
80107092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070a0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070a0:	a1 e4 88 11 80       	mov    0x801188e4,%eax
{
801070a5:	55                   	push   %ebp
801070a6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070a8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070ad:	0f 22 d8             	mov    %eax,%cr3
}
801070b0:	5d                   	pop    %ebp
801070b1:	c3                   	ret    
801070b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070c0 <switchuvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	8b 55 08             	mov    0x8(%ebp),%edx
  if(p == 0)
801070cc:	85 d2                	test   %edx,%edx
801070ce:	0f 84 db 00 00 00    	je     801071af <switchuvm+0xef>
  if(p->pgdir == 0)
801070d4:	8b 42 04             	mov    0x4(%edx),%eax
801070d7:	85 c0                	test   %eax,%eax
801070d9:	0f 84 ea 00 00 00    	je     801071c9 <switchuvm+0x109>
  t = p->pin;
801070df:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
  if(t->kstack == 0)
801070e5:	8b 79 04             	mov    0x4(%ecx),%edi
801070e8:	85 ff                	test   %edi,%edi
801070ea:	0f 84 cc 00 00 00    	je     801071bc <switchuvm+0xfc>
801070f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
801070f3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  pushcli();
801070f6:	e8 35 d6 ff ff       	call   80104730 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070fb:	e8 f0 c6 ff ff       	call   801037f0 <mycpu>
80107100:	89 c3                	mov    %eax,%ebx
80107102:	e8 e9 c6 ff ff       	call   801037f0 <mycpu>
80107107:	89 c7                	mov    %eax,%edi
80107109:	e8 e2 c6 ff ff       	call   801037f0 <mycpu>
8010710e:	89 c6                	mov    %eax,%esi
80107110:	83 c7 08             	add    $0x8,%edi
80107113:	83 c6 08             	add    $0x8,%esi
80107116:	c1 ee 10             	shr    $0x10,%esi
80107119:	e8 d2 c6 ff ff       	call   801037f0 <mycpu>
8010711e:	89 f1                	mov    %esi,%ecx
80107120:	83 c0 08             	add    $0x8,%eax
80107123:	ba 67 00 00 00       	mov    $0x67,%edx
80107128:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010712e:	c1 e8 18             	shr    $0x18,%eax
80107131:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107136:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010713d:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107144:	be ff ff ff ff       	mov    $0xffffffff,%esi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107149:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107150:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107156:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010715b:	e8 90 c6 ff ff       	call   801037f0 <mycpu>
80107160:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107167:	e8 84 c6 ff ff       	call   801037f0 <mycpu>
  mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
8010716c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010716f:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
80107173:	8b 59 04             	mov    0x4(%ecx),%ebx
80107176:	e8 75 c6 ff ff       	call   801037f0 <mycpu>
8010717b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107181:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107184:	e8 67 c6 ff ff       	call   801037f0 <mycpu>
80107189:	66 89 70 6e          	mov    %si,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010718d:	b8 28 00 00 00       	mov    $0x28,%eax
80107192:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107195:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107198:	8b 42 04             	mov    0x4(%edx),%eax
8010719b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071a0:	0f 22 d8             	mov    %eax,%cr3
}
801071a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071a6:	5b                   	pop    %ebx
801071a7:	5e                   	pop    %esi
801071a8:	5f                   	pop    %edi
801071a9:	5d                   	pop    %ebp
  popcli();
801071aa:	e9 c1 d5 ff ff       	jmp    80104770 <popcli>
    panic("switchuvm: no process");
801071af:	83 ec 0c             	sub    $0xc,%esp
801071b2:	68 06 8d 10 80       	push   $0x80108d06
801071b7:	e8 c4 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801071bc:	83 ec 0c             	sub    $0xc,%esp
801071bf:	68 30 8d 10 80       	push   $0x80108d30
801071c4:	e8 b7 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801071c9:	83 ec 0c             	sub    $0xc,%esp
801071cc:	68 1c 8d 10 80       	push   $0x80108d1c
801071d1:	e8 aa 91 ff ff       	call   80100380 <panic>
801071d6:	8d 76 00             	lea    0x0(%esi),%esi
801071d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071e0 <inituvm>:
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
801071e5:	53                   	push   %ebx
801071e6:	83 ec 1c             	sub    $0x1c,%esp
801071e9:	8b 75 10             	mov    0x10(%ebp),%esi
801071ec:	8b 45 08             	mov    0x8(%ebp),%eax
801071ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801071f2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801071f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801071fb:	77 49                	ja     80107246 <inituvm+0x66>
  mem = kalloc();
801071fd:	e8 9e b3 ff ff       	call   801025a0 <kalloc>
  memset(mem, 0, PGSIZE);
80107202:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107205:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107207:	68 00 10 00 00       	push   $0x1000
8010720c:	6a 00                	push   $0x0
8010720e:	50                   	push   %eax
8010720f:	e8 fc d6 ff ff       	call   80104910 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107214:	58                   	pop    %eax
80107215:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010721b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107220:	5a                   	pop    %edx
80107221:	6a 06                	push   $0x6
80107223:	50                   	push   %eax
80107224:	31 d2                	xor    %edx,%edx
80107226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107229:	e8 b2 fc ff ff       	call   80106ee0 <mappages>
  memmove(mem, init, sz);
8010722e:	89 75 10             	mov    %esi,0x10(%ebp)
80107231:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107234:	83 c4 10             	add    $0x10,%esp
80107237:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010723a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010723d:	5b                   	pop    %ebx
8010723e:	5e                   	pop    %esi
8010723f:	5f                   	pop    %edi
80107240:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107241:	e9 7a d7 ff ff       	jmp    801049c0 <memmove>
    panic("inituvm: more than a page");
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	68 45 8d 10 80       	push   $0x80108d45
8010724e:	e8 2d 91 ff ff       	call   80100380 <panic>
80107253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107260 <loaduvm>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	53                   	push   %ebx
80107266:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107269:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107270:	0f 85 91 00 00 00    	jne    80107307 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107276:	8b 75 18             	mov    0x18(%ebp),%esi
80107279:	31 db                	xor    %ebx,%ebx
8010727b:	85 f6                	test   %esi,%esi
8010727d:	75 1a                	jne    80107299 <loaduvm+0x39>
8010727f:	eb 6f                	jmp    801072f0 <loaduvm+0x90>
80107281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107288:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010728e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107294:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107297:	76 57                	jbe    801072f0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107299:	8b 55 0c             	mov    0xc(%ebp),%edx
8010729c:	8b 45 08             	mov    0x8(%ebp),%eax
8010729f:	31 c9                	xor    %ecx,%ecx
801072a1:	01 da                	add    %ebx,%edx
801072a3:	e8 b8 fb ff ff       	call   80106e60 <walkpgdir>
801072a8:	85 c0                	test   %eax,%eax
801072aa:	74 4e                	je     801072fa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801072ac:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801072b1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801072b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801072bb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801072c1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072c4:	01 d9                	add    %ebx,%ecx
801072c6:	05 00 00 00 80       	add    $0x80000000,%eax
801072cb:	57                   	push   %edi
801072cc:	51                   	push   %ecx
801072cd:	50                   	push   %eax
801072ce:	ff 75 10             	pushl  0x10(%ebp)
801072d1:	e8 6a a7 ff ff       	call   80101a40 <readi>
801072d6:	83 c4 10             	add    $0x10,%esp
801072d9:	39 f8                	cmp    %edi,%eax
801072db:	74 ab                	je     80107288 <loaduvm+0x28>
}
801072dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072e5:	5b                   	pop    %ebx
801072e6:	5e                   	pop    %esi
801072e7:	5f                   	pop    %edi
801072e8:	5d                   	pop    %ebp
801072e9:	c3                   	ret    
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072f3:	31 c0                	xor    %eax,%eax
}
801072f5:	5b                   	pop    %ebx
801072f6:	5e                   	pop    %esi
801072f7:	5f                   	pop    %edi
801072f8:	5d                   	pop    %ebp
801072f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801072fa:	83 ec 0c             	sub    $0xc,%esp
801072fd:	68 5f 8d 10 80       	push   $0x80108d5f
80107302:	e8 79 90 ff ff       	call   80100380 <panic>
    panic("loaduvm: addr must be page aligned");
80107307:	83 ec 0c             	sub    $0xc,%esp
8010730a:	68 00 8e 10 80       	push   $0x80108e00
8010730f:	e8 6c 90 ff ff       	call   80100380 <panic>
80107314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010731a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107320 <allocuvm>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107329:	8b 7d 10             	mov    0x10(%ebp),%edi
8010732c:	85 ff                	test   %edi,%edi
8010732e:	0f 88 8e 00 00 00    	js     801073c2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107334:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107337:	0f 82 93 00 00 00    	jb     801073d0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010733d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107340:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107346:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010734c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010734f:	0f 86 7e 00 00 00    	jbe    801073d3 <allocuvm+0xb3>
80107355:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107358:	8b 7d 08             	mov    0x8(%ebp),%edi
8010735b:	eb 42                	jmp    8010739f <allocuvm+0x7f>
8010735d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107360:	83 ec 04             	sub    $0x4,%esp
80107363:	68 00 10 00 00       	push   $0x1000
80107368:	6a 00                	push   $0x0
8010736a:	50                   	push   %eax
8010736b:	e8 a0 d5 ff ff       	call   80104910 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107370:	58                   	pop    %eax
80107371:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107377:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010737c:	5a                   	pop    %edx
8010737d:	6a 06                	push   $0x6
8010737f:	50                   	push   %eax
80107380:	89 da                	mov    %ebx,%edx
80107382:	89 f8                	mov    %edi,%eax
80107384:	e8 57 fb ff ff       	call   80106ee0 <mappages>
80107389:	83 c4 10             	add    $0x10,%esp
8010738c:	85 c0                	test   %eax,%eax
8010738e:	78 50                	js     801073e0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107390:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107396:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107399:	0f 86 81 00 00 00    	jbe    80107420 <allocuvm+0x100>
    mem = kalloc();
8010739f:	e8 fc b1 ff ff       	call   801025a0 <kalloc>
    if(mem == 0){
801073a4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801073a6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801073a8:	75 b6                	jne    80107360 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073aa:	83 ec 0c             	sub    $0xc,%esp
801073ad:	68 7d 8d 10 80       	push   $0x80108d7d
801073b2:	e8 99 92 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801073b7:	83 c4 10             	add    $0x10,%esp
801073ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801073bd:	39 45 10             	cmp    %eax,0x10(%ebp)
801073c0:	77 6e                	ja     80107430 <allocuvm+0x110>
}
801073c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801073c5:	31 ff                	xor    %edi,%edi
}
801073c7:	89 f8                	mov    %edi,%eax
801073c9:	5b                   	pop    %ebx
801073ca:	5e                   	pop    %esi
801073cb:	5f                   	pop    %edi
801073cc:	5d                   	pop    %ebp
801073cd:	c3                   	ret    
801073ce:	66 90                	xchg   %ax,%ax
    return oldsz;
801073d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801073d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d6:	89 f8                	mov    %edi,%eax
801073d8:	5b                   	pop    %ebx
801073d9:	5e                   	pop    %esi
801073da:	5f                   	pop    %edi
801073db:	5d                   	pop    %ebp
801073dc:	c3                   	ret    
801073dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801073e0:	83 ec 0c             	sub    $0xc,%esp
801073e3:	68 95 8d 10 80       	push   $0x80108d95
801073e8:	e8 63 92 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801073ed:	83 c4 10             	add    $0x10,%esp
801073f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f3:	39 45 10             	cmp    %eax,0x10(%ebp)
801073f6:	76 0d                	jbe    80107405 <allocuvm+0xe5>
801073f8:	89 c1                	mov    %eax,%ecx
801073fa:	8b 55 10             	mov    0x10(%ebp),%edx
801073fd:	8b 45 08             	mov    0x8(%ebp),%eax
80107400:	e8 6b fb ff ff       	call   80106f70 <deallocuvm.part.0>
      kfree(mem);
80107405:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107408:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010740a:	56                   	push   %esi
8010740b:	e8 e0 af ff ff       	call   801023f0 <kfree>
      return 0;
80107410:	83 c4 10             	add    $0x10,%esp
}
80107413:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107416:	89 f8                	mov    %edi,%eax
80107418:	5b                   	pop    %ebx
80107419:	5e                   	pop    %esi
8010741a:	5f                   	pop    %edi
8010741b:	5d                   	pop    %ebp
8010741c:	c3                   	ret    
8010741d:	8d 76 00             	lea    0x0(%esi),%esi
80107420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107423:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107426:	5b                   	pop    %ebx
80107427:	89 f8                	mov    %edi,%eax
80107429:	5e                   	pop    %esi
8010742a:	5f                   	pop    %edi
8010742b:	5d                   	pop    %ebp
8010742c:	c3                   	ret    
8010742d:	8d 76 00             	lea    0x0(%esi),%esi
80107430:	89 c1                	mov    %eax,%ecx
80107432:	8b 55 10             	mov    0x10(%ebp),%edx
80107435:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107438:	31 ff                	xor    %edi,%edi
8010743a:	e8 31 fb ff ff       	call   80106f70 <deallocuvm.part.0>
8010743f:	eb 92                	jmp    801073d3 <allocuvm+0xb3>
80107441:	eb 0d                	jmp    80107450 <deallocuvm>
80107443:	90                   	nop
80107444:	90                   	nop
80107445:	90                   	nop
80107446:	90                   	nop
80107447:	90                   	nop
80107448:	90                   	nop
80107449:	90                   	nop
8010744a:	90                   	nop
8010744b:	90                   	nop
8010744c:	90                   	nop
8010744d:	90                   	nop
8010744e:	90                   	nop
8010744f:	90                   	nop

80107450 <deallocuvm>:
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	8b 55 0c             	mov    0xc(%ebp),%edx
80107456:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107459:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010745c:	39 d1                	cmp    %edx,%ecx
8010745e:	73 10                	jae    80107470 <deallocuvm+0x20>
}
80107460:	5d                   	pop    %ebp
80107461:	e9 0a fb ff ff       	jmp    80106f70 <deallocuvm.part.0>
80107466:	8d 76 00             	lea    0x0(%esi),%esi
80107469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107470:	89 d0                	mov    %edx,%eax
80107472:	5d                   	pop    %ebp
80107473:	c3                   	ret    
80107474:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010747a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107480 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 0c             	sub    $0xc,%esp
80107489:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010748c:	85 f6                	test   %esi,%esi
8010748e:	74 59                	je     801074e9 <freevm+0x69>
80107490:	31 c9                	xor    %ecx,%ecx
80107492:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107497:	89 f0                	mov    %esi,%eax
80107499:	e8 d2 fa ff ff       	call   80106f70 <deallocuvm.part.0>
8010749e:	89 f3                	mov    %esi,%ebx
801074a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074a6:	eb 0f                	jmp    801074b7 <freevm+0x37>
801074a8:	90                   	nop
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074b0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074b3:	39 fb                	cmp    %edi,%ebx
801074b5:	74 23                	je     801074da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074b7:	8b 03                	mov    (%ebx),%eax
801074b9:	a8 01                	test   $0x1,%al
801074bb:	74 f3                	je     801074b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801074c2:	83 ec 0c             	sub    $0xc,%esp
801074c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801074cd:	50                   	push   %eax
801074ce:	e8 1d af ff ff       	call   801023f0 <kfree>
801074d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074d6:	39 fb                	cmp    %edi,%ebx
801074d8:	75 dd                	jne    801074b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801074da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801074dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074e0:	5b                   	pop    %ebx
801074e1:	5e                   	pop    %esi
801074e2:	5f                   	pop    %edi
801074e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801074e4:	e9 07 af ff ff       	jmp    801023f0 <kfree>
    panic("freevm: no pgdir");
801074e9:	83 ec 0c             	sub    $0xc,%esp
801074ec:	68 b1 8d 10 80       	push   $0x80108db1
801074f1:	e8 8a 8e ff ff       	call   80100380 <panic>
801074f6:	8d 76 00             	lea    0x0(%esi),%esi
801074f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107500 <setupkvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	56                   	push   %esi
80107504:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107505:	e8 96 b0 ff ff       	call   801025a0 <kalloc>
8010750a:	85 c0                	test   %eax,%eax
8010750c:	89 c6                	mov    %eax,%esi
8010750e:	74 42                	je     80107552 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107510:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107513:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107518:	68 00 10 00 00       	push   $0x1000
8010751d:	6a 00                	push   $0x0
8010751f:	50                   	push   %eax
80107520:	e8 eb d3 ff ff       	call   80104910 <memset>
80107525:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107528:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010752b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010752e:	83 ec 08             	sub    $0x8,%esp
80107531:	8b 13                	mov    (%ebx),%edx
80107533:	ff 73 0c             	pushl  0xc(%ebx)
80107536:	50                   	push   %eax
80107537:	29 c1                	sub    %eax,%ecx
80107539:	89 f0                	mov    %esi,%eax
8010753b:	e8 a0 f9 ff ff       	call   80106ee0 <mappages>
80107540:	83 c4 10             	add    $0x10,%esp
80107543:	85 c0                	test   %eax,%eax
80107545:	78 19                	js     80107560 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107547:	83 c3 10             	add    $0x10,%ebx
8010754a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107550:	75 d6                	jne    80107528 <setupkvm+0x28>
}
80107552:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107555:	89 f0                	mov    %esi,%eax
80107557:	5b                   	pop    %ebx
80107558:	5e                   	pop    %esi
80107559:	5d                   	pop    %ebp
8010755a:	c3                   	ret    
8010755b:	90                   	nop
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107560:	83 ec 0c             	sub    $0xc,%esp
80107563:	56                   	push   %esi
      return 0;
80107564:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107566:	e8 15 ff ff ff       	call   80107480 <freevm>
      return 0;
8010756b:	83 c4 10             	add    $0x10,%esp
}
8010756e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107571:	89 f0                	mov    %esi,%eax
80107573:	5b                   	pop    %ebx
80107574:	5e                   	pop    %esi
80107575:	5d                   	pop    %ebp
80107576:	c3                   	ret    
80107577:	89 f6                	mov    %esi,%esi
80107579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107580 <kvmalloc>:
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107586:	e8 75 ff ff ff       	call   80107500 <setupkvm>
8010758b:	a3 e4 88 11 80       	mov    %eax,0x801188e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107590:	05 00 00 00 80       	add    $0x80000000,%eax
80107595:	0f 22 d8             	mov    %eax,%cr3
}
80107598:	c9                   	leave  
80107599:	c3                   	ret    
8010759a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075a1:	31 c9                	xor    %ecx,%ecx
{
801075a3:	89 e5                	mov    %esp,%ebp
801075a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801075a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075ab:	8b 45 08             	mov    0x8(%ebp),%eax
801075ae:	e8 ad f8 ff ff       	call   80106e60 <walkpgdir>
  if(pte == 0)
801075b3:	85 c0                	test   %eax,%eax
801075b5:	74 05                	je     801075bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801075b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075ba:	c9                   	leave  
801075bb:	c3                   	ret    
    panic("clearpteu");
801075bc:	83 ec 0c             	sub    $0xc,%esp
801075bf:	68 c2 8d 10 80       	push   $0x80108dc2
801075c4:	e8 b7 8d ff ff       	call   80100380 <panic>
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	57                   	push   %edi
801075d4:	56                   	push   %esi
801075d5:	53                   	push   %ebx
801075d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801075d9:	e8 22 ff ff ff       	call   80107500 <setupkvm>
801075de:	85 c0                	test   %eax,%eax
801075e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075e3:	0f 84 9f 00 00 00    	je     80107688 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801075e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075ec:	85 c9                	test   %ecx,%ecx
801075ee:	0f 84 94 00 00 00    	je     80107688 <copyuvm+0xb8>
801075f4:	31 ff                	xor    %edi,%edi
801075f6:	eb 4a                	jmp    80107642 <copyuvm+0x72>
801075f8:	90                   	nop
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107600:	83 ec 04             	sub    $0x4,%esp
80107603:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107609:	68 00 10 00 00       	push   $0x1000
8010760e:	53                   	push   %ebx
8010760f:	50                   	push   %eax
80107610:	e8 ab d3 ff ff       	call   801049c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107615:	58                   	pop    %eax
80107616:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010761c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107621:	5a                   	pop    %edx
80107622:	ff 75 e4             	pushl  -0x1c(%ebp)
80107625:	50                   	push   %eax
80107626:	89 fa                	mov    %edi,%edx
80107628:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010762b:	e8 b0 f8 ff ff       	call   80106ee0 <mappages>
80107630:	83 c4 10             	add    $0x10,%esp
80107633:	85 c0                	test   %eax,%eax
80107635:	78 61                	js     80107698 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107637:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010763d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107640:	76 46                	jbe    80107688 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107642:	8b 45 08             	mov    0x8(%ebp),%eax
80107645:	31 c9                	xor    %ecx,%ecx
80107647:	89 fa                	mov    %edi,%edx
80107649:	e8 12 f8 ff ff       	call   80106e60 <walkpgdir>
8010764e:	85 c0                	test   %eax,%eax
80107650:	74 61                	je     801076b3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107652:	8b 00                	mov    (%eax),%eax
80107654:	a8 01                	test   $0x1,%al
80107656:	74 4e                	je     801076a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107658:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010765a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010765f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107665:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107668:	e8 33 af ff ff       	call   801025a0 <kalloc>
8010766d:	85 c0                	test   %eax,%eax
8010766f:	89 c6                	mov    %eax,%esi
80107671:	75 8d                	jne    80107600 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107673:	83 ec 0c             	sub    $0xc,%esp
80107676:	ff 75 e0             	pushl  -0x20(%ebp)
80107679:	e8 02 fe ff ff       	call   80107480 <freevm>
  return 0;
8010767e:	83 c4 10             	add    $0x10,%esp
80107681:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107688:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010768b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010768e:	5b                   	pop    %ebx
8010768f:	5e                   	pop    %esi
80107690:	5f                   	pop    %edi
80107691:	5d                   	pop    %ebp
80107692:	c3                   	ret    
80107693:	90                   	nop
80107694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107698:	83 ec 0c             	sub    $0xc,%esp
8010769b:	56                   	push   %esi
8010769c:	e8 4f ad ff ff       	call   801023f0 <kfree>
      goto bad;
801076a1:	83 c4 10             	add    $0x10,%esp
801076a4:	eb cd                	jmp    80107673 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801076a6:	83 ec 0c             	sub    $0xc,%esp
801076a9:	68 e6 8d 10 80       	push   $0x80108de6
801076ae:	e8 cd 8c ff ff       	call   80100380 <panic>
      panic("copyuvm: pte should exist");
801076b3:	83 ec 0c             	sub    $0xc,%esp
801076b6:	68 cc 8d 10 80       	push   $0x80108dcc
801076bb:	e8 c0 8c ff ff       	call   80100380 <panic>

801076c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076c1:	31 c9                	xor    %ecx,%ecx
{
801076c3:	89 e5                	mov    %esp,%ebp
801076c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801076c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801076cb:	8b 45 08             	mov    0x8(%ebp),%eax
801076ce:	e8 8d f7 ff ff       	call   80106e60 <walkpgdir>
  if((*pte & PTE_P) == 0)
801076d3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801076d5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801076d6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801076dd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076e0:	05 00 00 00 80       	add    $0x80000000,%eax
801076e5:	83 fa 05             	cmp    $0x5,%edx
801076e8:	ba 00 00 00 00       	mov    $0x0,%edx
801076ed:	0f 45 c2             	cmovne %edx,%eax
}
801076f0:	c3                   	ret    
801076f1:	eb 0d                	jmp    80107700 <copyout>
801076f3:	90                   	nop
801076f4:	90                   	nop
801076f5:	90                   	nop
801076f6:	90                   	nop
801076f7:	90                   	nop
801076f8:	90                   	nop
801076f9:	90                   	nop
801076fa:	90                   	nop
801076fb:	90                   	nop
801076fc:	90                   	nop
801076fd:	90                   	nop
801076fe:	90                   	nop
801076ff:	90                   	nop

80107700 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	57                   	push   %edi
80107704:	56                   	push   %esi
80107705:	53                   	push   %ebx
80107706:	83 ec 1c             	sub    $0x1c,%esp
80107709:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010770c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010770f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107712:	85 db                	test   %ebx,%ebx
80107714:	75 40                	jne    80107756 <copyout+0x56>
80107716:	eb 70                	jmp    80107788 <copyout+0x88>
80107718:	90                   	nop
80107719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107723:	89 f1                	mov    %esi,%ecx
80107725:	29 d1                	sub    %edx,%ecx
80107727:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010772d:	39 d9                	cmp    %ebx,%ecx
8010772f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107732:	29 f2                	sub    %esi,%edx
80107734:	83 ec 04             	sub    $0x4,%esp
80107737:	01 d0                	add    %edx,%eax
80107739:	51                   	push   %ecx
8010773a:	57                   	push   %edi
8010773b:	50                   	push   %eax
8010773c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010773f:	e8 7c d2 ff ff       	call   801049c0 <memmove>
    len -= n;
    buf += n;
80107744:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107747:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010774a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107750:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107752:	29 cb                	sub    %ecx,%ebx
80107754:	74 32                	je     80107788 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107756:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107758:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010775b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010775e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107764:	56                   	push   %esi
80107765:	ff 75 08             	pushl  0x8(%ebp)
80107768:	e8 53 ff ff ff       	call   801076c0 <uva2ka>
    if(pa0 == 0)
8010776d:	83 c4 10             	add    $0x10,%esp
80107770:	85 c0                	test   %eax,%eax
80107772:	75 ac                	jne    80107720 <copyout+0x20>
  }
  return 0;
}
80107774:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010777c:	5b                   	pop    %ebx
8010777d:	5e                   	pop    %esi
8010777e:	5f                   	pop    %edi
8010777f:	5d                   	pop    %ebp
80107780:	c3                   	ret    
80107781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107788:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010778b:	31 c0                	xor    %eax,%eax
}
8010778d:	5b                   	pop    %ebx
8010778e:	5e                   	pop    %esi
8010778f:	5f                   	pop    %edi
80107790:	5d                   	pop    %ebp
80107791:	c3                   	ret    
80107792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077a0 <ualloc>:

uint
ualloc(struct proc *p)
{
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	56                   	push   %esi
801077a4:	53                   	push   %ebx
801077a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint sz, sp;
  char *ustack;
  struct list *fstack;

  if((fstack = p->fslist) == 0){
801077a8:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
801077ae:	85 c0                	test   %eax,%eax
801077b0:	74 2e                	je     801077e0 <ualloc+0x40>
    sp = sz;
    p->sz = sz;
    ustack = uva2ka(p->pgdir, (char*)(sp - PGSIZE));
  }else{
    sp = fstack->usp;
    p->fslist = fstack->next;
801077b2:	8b 50 04             	mov    0x4(%eax),%edx
    sp = fstack->usp;
801077b5:	8b 30                	mov    (%eax),%esi
    p->fslist = fstack->next;
801077b7:	89 93 84 00 00 00    	mov    %edx,0x84(%ebx)
    ustack = (char*)fstack;
  }
  memset(ustack, 0, PGSIZE);
801077bd:	83 ec 04             	sub    $0x4,%esp
801077c0:	68 00 10 00 00       	push   $0x1000
801077c5:	6a 00                	push   $0x0
801077c7:	50                   	push   %eax
801077c8:	e8 43 d1 ff ff       	call   80104910 <memset>
  return sp;
801077cd:	83 c4 10             	add    $0x10,%esp
}
801077d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077d3:	89 f0                	mov    %esi,%eax
801077d5:	5b                   	pop    %ebx
801077d6:	5e                   	pop    %esi
801077d7:	5d                   	pop    %ebp
801077d8:	c3                   	ret    
801077d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sz = p->sz;
801077e0:	8b 03                	mov    (%ebx),%eax
    if((sz = allocuvm(p->pgdir, sz, sz + 2*PGSIZE)) == 0)
801077e2:	83 ec 04             	sub    $0x4,%esp
801077e5:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
801077eb:	52                   	push   %edx
801077ec:	50                   	push   %eax
801077ed:	ff 73 04             	pushl  0x4(%ebx)
801077f0:	e8 2b fb ff ff       	call   80107320 <allocuvm>
801077f5:	83 c4 10             	add    $0x10,%esp
801077f8:	85 c0                	test   %eax,%eax
801077fa:	89 c6                	mov    %eax,%esi
801077fc:	74 d2                	je     801077d0 <ualloc+0x30>
    clearpteu(p->pgdir, (char*)(sz - 2*PGSIZE));
801077fe:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80107804:	83 ec 08             	sub    $0x8,%esp
80107807:	50                   	push   %eax
80107808:	ff 73 04             	pushl  0x4(%ebx)
8010780b:	e8 90 fd ff ff       	call   801075a0 <clearpteu>
    p->sz = sz;
80107810:	89 33                	mov    %esi,(%ebx)
    ustack = uva2ka(p->pgdir, (char*)(sp - PGSIZE));
80107812:	58                   	pop    %eax
80107813:	8d 86 00 f0 ff ff    	lea    -0x1000(%esi),%eax
80107819:	5a                   	pop    %edx
8010781a:	50                   	push   %eax
8010781b:	ff 73 04             	pushl  0x4(%ebx)
8010781e:	e8 9d fe ff ff       	call   801076c0 <uva2ka>
80107823:	83 c4 10             	add    $0x10,%esp
80107826:	eb 95                	jmp    801077bd <ualloc+0x1d>
80107828:	90                   	nop
80107829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107830 <ufree>:

void
ufree(struct proc *p, uint sp)
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	57                   	push   %edi
80107834:	56                   	push   %esi
80107835:	53                   	push   %ebx
80107836:	83 ec 14             	sub    $0x14,%esp
80107839:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010783c:	8b 75 08             	mov    0x8(%ebp),%esi
  char *ustack;
  struct list *free;

  ustack = uva2ka(p->pgdir, (char*)(sp - PGSIZE));
8010783f:	8d 87 00 f0 ff ff    	lea    -0x1000(%edi),%eax
80107845:	50                   	push   %eax
80107846:	ff 76 04             	pushl  0x4(%esi)
80107849:	e8 72 fe ff ff       	call   801076c0 <uva2ka>
  memset(ustack, 0, PGSIZE);
8010784e:	83 c4 0c             	add    $0xc,%esp
  ustack = uva2ka(p->pgdir, (char*)(sp - PGSIZE));
80107851:	89 c3                	mov    %eax,%ebx
  memset(ustack, 0, PGSIZE);
80107853:	68 00 10 00 00       	push   $0x1000
80107858:	6a 00                	push   $0x0
8010785a:	50                   	push   %eax
8010785b:	e8 b0 d0 ff ff       	call   80104910 <memset>

  free = (struct list*)ustack;
  free->usp = sp;
80107860:	89 3b                	mov    %edi,(%ebx)
  free->next = p->fslist;
80107862:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  p->fslist = free;
}
80107868:	83 c4 10             	add    $0x10,%esp
  free->next = p->fslist;
8010786b:	89 43 04             	mov    %eax,0x4(%ebx)
  p->fslist = free;
8010786e:	89 9e 84 00 00 00    	mov    %ebx,0x84(%esi)
}
80107874:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107877:	5b                   	pop    %ebx
80107878:	5e                   	pop    %esi
80107879:	5f                   	pop    %edi
8010787a:	5d                   	pop    %ebp
8010787b:	c3                   	ret    
8010787c:	66 90                	xchg   %ax,%ax
8010787e:	66 90                	xchg   %ax,%ax

80107880 <boost.part.0>:
} stride = { 5 };

// Operating_Systems_Projects01
// Boosting MLFQ scheduler.
void
boost(void)
80107880:	55                   	push   %ebp
  struct proc *p;

  if(mlfq.boosted < 200)
    return;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80107881:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
boost(void)
80107886:	89 e5                	mov    %esp,%ebp
80107888:	eb 12                	jmp    8010789c <boost.part.0+0x1c>
8010788a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80107890:	05 8c 00 00 00       	add    $0x8c,%eax
80107895:	3d 94 60 11 80       	cmp    $0x80116094,%eax
8010789a:	73 2a                	jae    801078c6 <boost.part.0+0x46>
    if(p->stype == MLFQ && p->qlev > HQLEV){
8010789c:	83 78 70 01          	cmpl   $0x1,0x70(%eax)
801078a0:	75 ee                	jne    80107890 <boost.part.0+0x10>
801078a2:	8b 50 74             	mov    0x74(%eax),%edx
801078a5:	85 d2                	test   %edx,%edx
801078a7:	74 e7                	je     80107890 <boost.part.0+0x10>
      p->qlev = HQLEV;
801078a9:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
      p->pass = 0;
801078b0:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801078b7:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801078ba:	05 8c 00 00 00       	add    $0x8c,%eax
801078bf:	3d 94 60 11 80       	cmp    $0x80116094,%eax
801078c4:	72 d6                	jb     8010789c <boost.part.0+0x1c>
    }
  }
  mlfq.boosted = 0;
801078c6:	c7 05 7c b4 10 80 00 	movl   $0x0,0x8010b47c
801078cd:	00 00 00 
}
801078d0:	5d                   	pop    %ebp
801078d1:	c3                   	ret    
801078d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078e0 <boost>:
  if(mlfq.boosted < 200)
801078e0:	81 3d 7c b4 10 80 c7 	cmpl   $0xc7,0x8010b47c
801078e7:	00 00 00 
{
801078ea:	55                   	push   %ebp
801078eb:	89 e5                	mov    %esp,%ebp
  if(mlfq.boosted < 200)
801078ed:	76 09                	jbe    801078f8 <boost+0x18>
}
801078ef:	5d                   	pop    %ebp
801078f0:	eb 8e                	jmp    80107880 <boost.part.0>
801078f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078f8:	5d                   	pop    %ebp
801078f9:	c3                   	ret    
801078fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107900 <reduce>:
void
reduce(void)
{
  struct proc *p;

  if(mlfq.pass < MAXPASS)
80107900:	8b 15 78 b4 10 80    	mov    0x8010b478,%edx
{
80107906:	55                   	push   %ebp
80107907:	89 e5                	mov    %esp,%ebp
  if(mlfq.pass < MAXPASS)
80107909:	81 fa ff e0 f5 05    	cmp    $0x5f5e0ff,%edx
8010790f:	76 2d                	jbe    8010793e <reduce+0x3e>
    return;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80107911:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
80107916:	eb 14                	jmp    8010792c <reduce+0x2c>
80107918:	90                   	nop
80107919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107920:	05 8c 00 00 00       	add    $0x8c,%eax
80107925:	3d 94 60 11 80       	cmp    $0x80116094,%eax
8010792a:	73 14                	jae    80107940 <reduce+0x40>
    if(p->stype == STRIDE && p->pass < MAXPASS)
8010792c:	83 78 70 02          	cmpl   $0x2,0x70(%eax)
80107930:	75 ee                	jne    80107920 <reduce+0x20>
80107932:	81 b8 80 00 00 00 ff 	cmpl   $0x5f5e0ff,0x80(%eax)
80107939:	e0 f5 05 
8010793c:	77 e2                	ja     80107920 <reduce+0x20>

  mlfq.pass -= MAXPASS;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->stype == STRIDE)
      p->pass -= MAXPASS;
}
8010793e:	5d                   	pop    %ebp
8010793f:	c3                   	ret    
  mlfq.pass -= MAXPASS;
80107940:	81 ea 00 e1 f5 05    	sub    $0x5f5e100,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80107946:	b8 94 3d 11 80       	mov    $0x80113d94,%eax
  mlfq.pass -= MAXPASS;
8010794b:	89 15 78 b4 10 80    	mov    %edx,0x8010b478
80107951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->stype == STRIDE)
80107958:	83 78 70 02          	cmpl   $0x2,0x70(%eax)
8010795c:	75 0a                	jne    80107968 <reduce+0x68>
      p->pass -= MAXPASS;
8010795e:	81 a8 80 00 00 00 00 	subl   $0x5f5e100,0x80(%eax)
80107965:	e1 f5 05 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80107968:	05 8c 00 00 00       	add    $0x8c,%eax
8010796d:	3d 94 60 11 80       	cmp    $0x80116094,%eax
80107972:	72 e4                	jb     80107958 <reduce+0x58>
}
80107974:	5d                   	pop    %ebp
80107975:	c3                   	ret    
80107976:	8d 76 00             	lea    0x0(%esi),%esi
80107979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107980 <getstrideproc>:
// Find process which have minimum value of pass.
// If there is no process in each scheduling, return 0.
// else return min pass value process.
struct proc *
getstrideproc(void)
{
80107980:	55                   	push   %ebp
  struct proc *minproc = 0;
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80107981:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
  struct proc *minproc = 0;
80107986:	31 c0                	xor    %eax,%eax
{
80107988:	89 e5                	mov    %esp,%ebp
8010798a:	eb 12                	jmp    8010799e <getstrideproc+0x1e>
8010798c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80107990:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80107996:	81 fa 94 60 11 80    	cmp    $0x80116094,%edx
8010799c:	73 2d                	jae    801079cb <getstrideproc+0x4b>
    if(p->stype == STRIDE && p->state == RUNNABLE){
8010799e:	83 7a 70 02          	cmpl   $0x2,0x70(%edx)
801079a2:	75 ec                	jne    80107990 <getstrideproc+0x10>
801079a4:	83 7a 08 05          	cmpl   $0x5,0x8(%edx)
801079a8:	75 e6                	jne    80107990 <getstrideproc+0x10>
      if(!minproc)
801079aa:	85 c0                	test   %eax,%eax
801079ac:	74 22                	je     801079d0 <getstrideproc+0x50>
        minproc = p;
      else if(p->pass < minproc->pass)
801079ae:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
801079b4:	39 8a 80 00 00 00    	cmp    %ecx,0x80(%edx)
801079ba:	0f 42 c2             	cmovb  %edx,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801079bd:	81 c2 8c 00 00 00    	add    $0x8c,%edx
801079c3:	81 fa 94 60 11 80    	cmp    $0x80116094,%edx
801079c9:	72 d3                	jb     8010799e <getstrideproc+0x1e>
        minproc = p;
    }
  }
  return minproc;
}
801079cb:	5d                   	pop    %ebp
801079cc:	c3                   	ret    
801079cd:	8d 76 00             	lea    0x0(%esi),%esi
801079d0:	89 d0                	mov    %edx,%eax
801079d2:	eb bc                	jmp    80107990 <getstrideproc+0x10>
801079d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801079e0 <getmlfqproc>:
struct proc *
getmlfqproc(void)
{
  struct proc *p;

  p = mlfq.pin + 1;
801079e0:	8b 15 80 b4 10 80    	mov    0x8010b480,%edx
{
801079e6:	55                   	push   %ebp
      if(p->stype == MLFQ && p->state == RUNNABLE)
        return p;
      if(p == mlfq.pin)
        return 0;
    }
    p = ptable.proc;
801079e7:	b9 94 3d 11 80       	mov    $0x80113d94,%ecx
{
801079ec:	89 e5                	mov    %esp,%ebp
  p = mlfq.pin + 1;
801079ee:	8d 82 8c 00 00 00    	lea    0x8c(%edx),%eax
801079f4:	eb 13                	jmp    80107a09 <getmlfqproc+0x29>
801079f6:	8d 76 00             	lea    0x0(%esi),%esi
801079f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p == mlfq.pin)
80107a00:	39 c2                	cmp    %eax,%edx
80107a02:	74 1c                	je     80107a20 <getmlfqproc+0x40>
    for(; p < &ptable.proc[NPROC]; p++){
80107a04:	05 8c 00 00 00       	add    $0x8c,%eax
    p = ptable.proc;
80107a09:	3d 94 60 11 80       	cmp    $0x80116094,%eax
80107a0e:	0f 43 c1             	cmovae %ecx,%eax
      if(p->stype == MLFQ && p->state == RUNNABLE)
80107a11:	83 78 70 01          	cmpl   $0x1,0x70(%eax)
80107a15:	75 e9                	jne    80107a00 <getmlfqproc+0x20>
80107a17:	83 78 08 05          	cmpl   $0x5,0x8(%eax)
80107a1b:	75 e3                	jne    80107a00 <getmlfqproc+0x20>
  }
}
80107a1d:	5d                   	pop    %ebp
80107a1e:	c3                   	ret    
80107a1f:	90                   	nop
        return 0;
80107a20:	31 c0                	xor    %eax,%eax
}
80107a22:	5d                   	pop    %ebp
80107a23:	c3                   	ret    
80107a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a30 <getschedproc>:

struct proc *
getschedproc(void)
{
80107a30:	55                   	push   %ebp
  struct proc *minproc = 0;
80107a31:	31 c0                	xor    %eax,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80107a33:	ba 94 3d 11 80       	mov    $0x80113d94,%edx
{
80107a38:	89 e5                	mov    %esp,%ebp
80107a3a:	53                   	push   %ebx
80107a3b:	eb 11                	jmp    80107a4e <getschedproc+0x1e>
80107a3d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80107a40:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80107a46:	81 fa 94 60 11 80    	cmp    $0x80116094,%edx
80107a4c:	73 32                	jae    80107a80 <getschedproc+0x50>
    if(p->stype == STRIDE && p->state == RUNNABLE){
80107a4e:	83 7a 70 02          	cmpl   $0x2,0x70(%edx)
80107a52:	75 ec                	jne    80107a40 <getschedproc+0x10>
80107a54:	83 7a 08 05          	cmpl   $0x5,0x8(%edx)
80107a58:	75 e6                	jne    80107a40 <getschedproc+0x10>
      if(!minproc)
80107a5a:	85 c0                	test   %eax,%eax
80107a5c:	74 7a                	je     80107ad8 <getschedproc+0xa8>
      else if(p->pass < minproc->pass)
80107a5e:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
80107a64:	39 9a 80 00 00 00    	cmp    %ebx,0x80(%edx)
80107a6a:	0f 42 c2             	cmovb  %edx,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80107a6d:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80107a73:	81 fa 94 60 11 80    	cmp    $0x80116094,%edx
80107a79:	72 d3                	jb     80107a4e <getschedproc+0x1e>
80107a7b:	90                   	nop
80107a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  p = mlfq.pin + 1;
80107a80:	8b 0d 80 b4 10 80    	mov    0x8010b480,%ecx
    p = ptable.proc;
80107a86:	bb 94 3d 11 80       	mov    $0x80113d94,%ebx
  p = mlfq.pin + 1;
80107a8b:	8d 91 8c 00 00 00    	lea    0x8c(%ecx),%edx
80107a91:	eb 0f                	jmp    80107aa2 <getschedproc+0x72>
80107a93:	90                   	nop
80107a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p == mlfq.pin)
80107a98:	39 d1                	cmp    %edx,%ecx
80107a9a:	74 35                	je     80107ad1 <getschedproc+0xa1>
    for(; p < &ptable.proc[NPROC]; p++){
80107a9c:	81 c2 8c 00 00 00    	add    $0x8c,%edx
    p = ptable.proc;
80107aa2:	81 fa 94 60 11 80    	cmp    $0x80116094,%edx
80107aa8:	0f 43 d3             	cmovae %ebx,%edx
      if(p->stype == MLFQ && p->state == RUNNABLE)
80107aab:	83 7a 70 01          	cmpl   $0x1,0x70(%edx)
80107aaf:	75 e7                	jne    80107a98 <getschedproc+0x68>
80107ab1:	83 7a 08 05          	cmpl   $0x5,0x8(%edx)
80107ab5:	75 e1                	jne    80107a98 <getschedproc+0x68>
  struct proc *p;
  struct proc *p1 = getstrideproc();
  struct proc *p2 = getmlfqproc();

  if(p1 && p2)
80107ab7:	85 c0                	test   %eax,%eax
80107ab9:	74 0e                	je     80107ac9 <getschedproc+0x99>
    p = p1->pass < mlfq.pass ? p1 : p2;
80107abb:	8b 0d 78 b4 10 80    	mov    0x8010b478,%ecx
80107ac1:	39 88 80 00 00 00    	cmp    %ecx,0x80(%eax)
80107ac7:	72 16                	jb     80107adf <getschedproc+0xaf>
80107ac9:	89 d0                	mov    %edx,%eax
    p = p2;
  else
    p = 0;

  if(p2 && p == p2)
    mlfq.pin = p2;
80107acb:	89 15 80 b4 10 80    	mov    %edx,0x8010b480
  return p;
}
80107ad1:	5b                   	pop    %ebx
80107ad2:	5d                   	pop    %ebp
80107ad3:	c3                   	ret    
80107ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(!minproc)
80107ad8:	89 d0                	mov    %edx,%eax
80107ada:	e9 61 ff ff ff       	jmp    80107a40 <getschedproc+0x10>
  if(p2 && p == p2)
80107adf:	39 d0                	cmp    %edx,%eax
80107ae1:	74 e8                	je     80107acb <getschedproc+0x9b>
}
80107ae3:	5b                   	pop    %ebx
80107ae4:	5d                   	pop    %ebp
80107ae5:	c3                   	ret    
80107ae6:	8d 76 00             	lea    0x0(%esi),%esi
80107ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107af0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	57                   	push   %edi
80107af4:	56                   	push   %esi
80107af5:	53                   	push   %ebx
80107af6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct thread *t;
  struct cpu *c = mycpu();
80107af9:	e8 f2 bc ff ff       	call   801037f0 <mycpu>
  c->proc = 0;
80107afe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80107b05:	00 00 00 
  struct cpu *c = mycpu();
80107b08:	89 c6                	mov    %eax,%esi
      switchuvm(p);

      p->ticks = 0;
      setstate(p, t, RUNNING);

      swtch(&(c->scheduler), t->context);
80107b0a:	8d 40 04             	lea    0x4(%eax),%eax
80107b0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b10:	e9 c3 00 00 00       	jmp    80107bd8 <scheduler+0xe8>
80107b15:	8d 76 00             	lea    0x0(%esi),%esi
    if((p = getschedproc())){
80107b18:	e8 13 ff ff ff       	call   80107a30 <getschedproc>
80107b1d:	85 c0                	test   %eax,%eax
80107b1f:	89 c3                	mov    %eax,%ebx
80107b21:	0f 84 a1 00 00 00    	je     80107bc8 <scheduler+0xd8>
      if((t = nextthd(p)) == 0)
80107b27:	83 ec 0c             	sub    $0xc,%esp
80107b2a:	50                   	push   %eax
80107b2b:	e8 b0 08 00 00       	call   801083e0 <nextthd>
80107b30:	83 c4 10             	add    $0x10,%esp
80107b33:	85 c0                	test   %eax,%eax
80107b35:	89 c7                	mov    %eax,%edi
80107b37:	0f 84 e3 00 00 00    	je     80107c20 <scheduler+0x130>
      switchuvm(p);
80107b3d:	83 ec 0c             	sub    $0xc,%esp
      c->thd = t;
80107b40:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
      c->proc = p;
80107b46:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80107b4c:	53                   	push   %ebx
80107b4d:	e8 6e f5 ff ff       	call   801070c0 <switchuvm>
      setstate(p, t, RUNNING);
80107b52:	83 c4 0c             	add    $0xc,%esp
      p->ticks = 0;
80107b55:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
      setstate(p, t, RUNNING);
80107b5c:	6a 04                	push   $0x4
80107b5e:	57                   	push   %edi
80107b5f:	53                   	push   %ebx
80107b60:	e8 8b bd ff ff       	call   801038f0 <setstate>
      swtch(&(c->scheduler), t->context);
80107b65:	58                   	pop    %eax
80107b66:	5a                   	pop    %edx
80107b67:	ff 77 18             	pushl  0x18(%edi)
80107b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
80107b6d:	e8 d9 cf ff ff       	call   80104b4b <swtch>
      switchkvm();
80107b72:	e8 29 f5 ff ff       	call   801070a0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80107b77:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80107b7e:	00 00 00 
      c->thd = 0;
80107b81:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
80107b88:	00 00 00 

      if(p->stype == STRIDE)
80107b8b:	83 c4 10             	add    $0x10,%esp
80107b8e:	8b 4b 70             	mov    0x70(%ebx),%ecx
        p->pass += TICKETS * p->ticks / p->share;
80107b91:	31 d2                	xor    %edx,%edx
80107b93:	69 43 78 10 27 00 00 	imul   $0x2710,0x78(%ebx),%eax
      if(p->stype == STRIDE)
80107b9a:	83 f9 02             	cmp    $0x2,%ecx
80107b9d:	74 71                	je     80107c10 <scheduler+0x120>
      else{
        mlfq.pass += TICKETS * p->ticks / mlfq.share;
80107b9f:	f7 35 74 b4 10 80    	divl   0x8010b474
80107ba5:	01 05 78 b4 10 80    	add    %eax,0x8010b478
        mlfq.boosted += p->ticks;
80107bab:	8b 43 78             	mov    0x78(%ebx),%eax
80107bae:	01 05 7c b4 10 80    	add    %eax,0x8010b47c
      }

      // When MLFQ process' pass is more than time allotment,
      // decrease queue level.
      if(p->stype == MLFQ && p->qlev < LQLEV)
80107bb4:	83 f9 01             	cmp    $0x1,%ecx
80107bb7:	75 0f                	jne    80107bc8 <scheduler+0xd8>
80107bb9:	8b 43 74             	mov    0x74(%ebx),%eax
80107bbc:	83 f8 01             	cmp    $0x1,%eax
80107bbf:	76 6f                	jbe    80107c30 <scheduler+0x140>
80107bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(p->pass >= mlfq.allot[p->qlev]) {
          p->qlev++;
          p->pass = 0;
        }
    }
    release(&ptable.lock);
80107bc8:	83 ec 0c             	sub    $0xc,%esp
80107bcb:	68 60 3d 11 80       	push   $0x80113d60
80107bd0:	e8 eb cc ff ff       	call   801048c0 <release>
    sti();
80107bd5:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80107bd8:	fb                   	sti    
    acquire(&ptable.lock);
80107bd9:	83 ec 0c             	sub    $0xc,%esp
80107bdc:	68 60 3d 11 80       	push   $0x80113d60
80107be1:	e8 1a cc ff ff       	call   80104800 <acquire>
    reduce();
80107be6:	e8 15 fd ff ff       	call   80107900 <reduce>
  if(mlfq.boosted < 200)
80107beb:	83 c4 10             	add    $0x10,%esp
80107bee:	81 3d 7c b4 10 80 c7 	cmpl   $0xc7,0x8010b47c
80107bf5:	00 00 00 
80107bf8:	0f 86 1a ff ff ff    	jbe    80107b18 <scheduler+0x28>
80107bfe:	e8 7d fc ff ff       	call   80107880 <boost.part.0>
80107c03:	e9 10 ff ff ff       	jmp    80107b18 <scheduler+0x28>
80107c08:	90                   	nop
80107c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->pass += TICKETS * p->ticks / p->share;
80107c10:	f7 73 7c             	divl   0x7c(%ebx)
80107c13:	01 83 80 00 00 00    	add    %eax,0x80(%ebx)
80107c19:	eb ad                	jmp    80107bc8 <scheduler+0xd8>
80107c1b:	90                   	nop
80107c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        panic("no thread in process (scheduler)");
80107c20:	83 ec 0c             	sub    $0xc,%esp
80107c23:	68 24 8e 10 80       	push   $0x80108e24
80107c28:	e8 53 87 ff ff       	call   80100380 <panic>
80107c2d:	8d 76 00             	lea    0x0(%esi),%esi
        if(p->pass >= mlfq.allot[p->qlev]) {
80107c30:	8b 14 85 6c b4 10 80 	mov    -0x7fef4b94(,%eax,4),%edx
80107c37:	39 93 80 00 00 00    	cmp    %edx,0x80(%ebx)
80107c3d:	72 89                	jb     80107bc8 <scheduler+0xd8>
          p->qlev++;
80107c3f:	83 c0 01             	add    $0x1,%eax
          p->pass = 0;
80107c42:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80107c49:	00 00 00 
          p->qlev++;
80107c4c:	89 43 74             	mov    %eax,0x74(%ebx)
80107c4f:	e9 74 ff ff ff       	jmp    80107bc8 <scheduler+0xd8>
80107c54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c60 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	57                   	push   %edi
80107c64:	56                   	push   %esi
80107c65:	53                   	push   %ebx
80107c66:	83 ec 1c             	sub    $0x1c,%esp
  int intena;
  uint quan;
  struct thread *t;
  struct proc *curproc = myproc();
80107c69:	e8 22 bc ff ff       	call   80103890 <myproc>
80107c6e:	89 c3                	mov    %eax,%ebx
  struct thread *curthd = mythd();
80107c70:	e8 4b bc ff ff       	call   801038c0 <mythd>

  if(!holding(&ptable.lock))
80107c75:	83 ec 0c             	sub    $0xc,%esp
  struct thread *curthd = mythd();
80107c78:	89 c6                	mov    %eax,%esi
  if(!holding(&ptable.lock))
80107c7a:	68 60 3d 11 80       	push   $0x80113d60
80107c7f:	e8 4c cb ff ff       	call   801047d0 <holding>
80107c84:	83 c4 10             	add    $0x10,%esp
80107c87:	85 c0                	test   %eax,%eax
80107c89:	0f 84 1b 01 00 00    	je     80107daa <sched+0x14a>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80107c8f:	e8 5c bb ff ff       	call   801037f0 <mycpu>
80107c94:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80107c9b:	0f 85 30 01 00 00    	jne    80107dd1 <sched+0x171>
    panic("sched locks");
  if(curthd->state == RUNNING)
80107ca1:	83 7e 08 04          	cmpl   $0x4,0x8(%esi)
80107ca5:	0f 84 19 01 00 00    	je     80107dc4 <sched+0x164>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80107cab:	9c                   	pushf  
80107cac:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80107cad:	f6 c4 02             	test   $0x2,%ah
80107cb0:	0f 85 01 01 00 00    	jne    80107db7 <sched+0x157>
    panic("sched interruptible");

  curproc->ticks++;
80107cb6:	8b 43 78             	mov    0x78(%ebx),%eax
  if(curproc->stype == MLFQ)
80107cb9:	8b 53 70             	mov    0x70(%ebx),%edx
  curproc->ticks++;
80107cbc:	83 c0 01             	add    $0x1,%eax
  if(curproc->stype == MLFQ)
80107cbf:	83 fa 01             	cmp    $0x1,%edx
  curproc->ticks++;
80107cc2:	89 43 78             	mov    %eax,0x78(%ebx)
  if(curproc->stype == MLFQ)
80107cc5:	74 49                	je     80107d10 <sched+0xb0>
    curproc->pass++;

  if(curproc->stype == STRIDE)
80107cc7:	83 fa 02             	cmp    $0x2,%edx
    quan = stride.quan;
80107cca:	b9 05 00 00 00       	mov    $0x5,%ecx
  if(curproc->stype == STRIDE)
80107ccf:	75 46                	jne    80107d17 <sched+0xb7>
  else
    quan = mlfq.quan[curproc->qlev];

  if(curproc->state == RUNNABLE && curproc->ticks < quan){
80107cd1:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
80107cd5:	75 04                	jne    80107cdb <sched+0x7b>
80107cd7:	39 c8                	cmp    %ecx,%eax
80107cd9:	72 4d                	jb     80107d28 <sched+0xc8>
      swtch(&curthd->context, t->context);
      mycpu()->intena = intena;
    }
  }else{
    // Scheduler swtich.
    intena = mycpu()->intena;
80107cdb:	e8 10 bb ff ff       	call   801037f0 <mycpu>
    swtch(&curthd->context, mycpu()->scheduler);
80107ce0:	83 c6 18             	add    $0x18,%esi
    intena = mycpu()->intena;
80107ce3:	8b 98 a8 00 00 00    	mov    0xa8(%eax),%ebx
    swtch(&curthd->context, mycpu()->scheduler);
80107ce9:	e8 02 bb ff ff       	call   801037f0 <mycpu>
80107cee:	83 ec 08             	sub    $0x8,%esp
80107cf1:	ff 70 04             	pushl  0x4(%eax)
80107cf4:	56                   	push   %esi
80107cf5:	e8 51 ce ff ff       	call   80104b4b <swtch>
    mycpu()->intena = intena;
80107cfa:	e8 f1 ba ff ff       	call   801037f0 <mycpu>
80107cff:	83 c4 10             	add    $0x10,%esp
80107d02:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  }
}
80107d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d0b:	5b                   	pop    %ebx
80107d0c:	5e                   	pop    %esi
80107d0d:	5f                   	pop    %edi
80107d0e:	5d                   	pop    %ebp
80107d0f:	c3                   	ret    
    curproc->pass++;
80107d10:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
    quan = mlfq.quan[curproc->qlev];
80107d17:	8b 53 74             	mov    0x74(%ebx),%edx
80107d1a:	8b 0c 95 60 b4 10 80 	mov    -0x7fef4ba0(,%edx,4),%ecx
80107d21:	eb ae                	jmp    80107cd1 <sched+0x71>
80107d23:	90                   	nop
80107d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((t = nextthd(curproc)) == 0)
80107d28:	83 ec 0c             	sub    $0xc,%esp
80107d2b:	53                   	push   %ebx
80107d2c:	e8 af 06 00 00       	call   801083e0 <nextthd>
80107d31:	83 c4 10             	add    $0x10,%esp
80107d34:	85 c0                	test   %eax,%eax
80107d36:	89 c7                	mov    %eax,%edi
80107d38:	0f 84 a0 00 00 00    	je     80107dde <sched+0x17e>
    setstate(curproc, t, RUNNING);
80107d3e:	83 ec 04             	sub    $0x4,%esp
80107d41:	6a 04                	push   $0x4
80107d43:	50                   	push   %eax
80107d44:	53                   	push   %ebx
80107d45:	e8 a6 bb ff ff       	call   801038f0 <setstate>
    if(curthd != t){
80107d4a:	83 c4 10             	add    $0x10,%esp
80107d4d:	39 fe                	cmp    %edi,%esi
80107d4f:	74 b7                	je     80107d08 <sched+0xa8>
      intena = mycpu()->intena;
80107d51:	e8 9a ba ff ff       	call   801037f0 <mycpu>
80107d56:	8b 90 a8 00 00 00    	mov    0xa8(%eax),%edx
      swtch(&curthd->context, t->context);
80107d5c:	83 c6 18             	add    $0x18,%esi
      intena = mycpu()->intena;
80107d5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      mycpu()->thd = t;
80107d62:	e8 89 ba ff ff       	call   801037f0 <mycpu>
80107d67:	89 b8 b0 00 00 00    	mov    %edi,0xb0(%eax)
      pushcli();
80107d6d:	e8 be c9 ff ff       	call   80104730 <pushcli>
      mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
80107d72:	8b 5f 04             	mov    0x4(%edi),%ebx
80107d75:	e8 76 ba ff ff       	call   801037f0 <mycpu>
80107d7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d80:	89 58 0c             	mov    %ebx,0xc(%eax)
      popcli();
80107d83:	e8 e8 c9 ff ff       	call   80104770 <popcli>
      swtch(&curthd->context, t->context);
80107d88:	83 ec 08             	sub    $0x8,%esp
80107d8b:	ff 77 18             	pushl  0x18(%edi)
80107d8e:	56                   	push   %esi
80107d8f:	e8 b7 cd ff ff       	call   80104b4b <swtch>
      mycpu()->intena = intena;
80107d94:	e8 57 ba ff ff       	call   801037f0 <mycpu>
80107d99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d9c:	83 c4 10             	add    $0x10,%esp
80107d9f:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
80107da5:	e9 5e ff ff ff       	jmp    80107d08 <sched+0xa8>
    panic("sched ptable.lock");
80107daa:	83 ec 0c             	sub    $0xc,%esp
80107dad:	68 48 8e 10 80       	push   $0x80108e48
80107db2:	e8 c9 85 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80107db7:	83 ec 0c             	sub    $0xc,%esp
80107dba:	68 74 8e 10 80       	push   $0x80108e74
80107dbf:	e8 bc 85 ff ff       	call   80100380 <panic>
    panic("sched running");
80107dc4:	83 ec 0c             	sub    $0xc,%esp
80107dc7:	68 66 8e 10 80       	push   $0x80108e66
80107dcc:	e8 af 85 ff ff       	call   80100380 <panic>
    panic("sched locks");
80107dd1:	83 ec 0c             	sub    $0xc,%esp
80107dd4:	68 5a 8e 10 80       	push   $0x80108e5a
80107dd9:	e8 a2 85 ff ff       	call   80100380 <panic>
      panic("no thread in process (sched)");
80107dde:	83 ec 0c             	sub    $0xc,%esp
80107de1:	68 88 8e 10 80       	push   $0x80108e88
80107de6:	e8 95 85 ff ff       	call   80100380 <panic>
80107deb:	90                   	nop
80107dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107df0 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80107df0:	55                   	push   %ebp
80107df1:	89 e5                	mov    %esp,%ebp
80107df3:	56                   	push   %esi
80107df4:	53                   	push   %ebx
  struct proc *p = myproc();
80107df5:	e8 96 ba ff ff       	call   80103890 <myproc>
80107dfa:	89 c3                	mov    %eax,%ebx
  struct thread *t = mythd();
80107dfc:	e8 bf ba ff ff       	call   801038c0 <mythd>

  acquire(&ptable.lock);  //DOC: yieldlock
80107e01:	83 ec 0c             	sub    $0xc,%esp
  struct thread *t = mythd();
80107e04:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);  //DOC: yieldlock
80107e06:	68 60 3d 11 80       	push   $0x80113d60
80107e0b:	e8 f0 c9 ff ff       	call   80104800 <acquire>
  setstate(p, t, RUNNABLE);
80107e10:	83 c4 0c             	add    $0xc,%esp
80107e13:	6a 05                	push   $0x5
80107e15:	56                   	push   %esi
80107e16:	53                   	push   %ebx
80107e17:	e8 d4 ba ff ff       	call   801038f0 <setstate>

  sched();
80107e1c:	e8 3f fe ff ff       	call   80107c60 <sched>
  release(&ptable.lock);
80107e21:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80107e28:	e8 93 ca ff ff       	call   801048c0 <release>
}
80107e2d:	83 c4 10             	add    $0x10,%esp
80107e30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e33:	5b                   	pop    %ebx
80107e34:	5e                   	pop    %esi
80107e35:	5d                   	pop    %ebp
80107e36:	c3                   	ret    
80107e37:	89 f6                	mov    %esi,%esi
80107e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e40 <set_cpu_share>:

// Operating_Systems_Projects01
// Change MLFQ process to Stride scheduling.
int
set_cpu_share(int share)
{
80107e40:	55                   	push   %ebp
80107e41:	89 e5                	mov    %esp,%ebp
80107e43:	56                   	push   %esi
80107e44:	53                   	push   %ebx
80107e45:	8b 75 08             	mov    0x8(%ebp),%esi
  uint new;
  struct proc *curproc = myproc();
80107e48:	e8 43 ba ff ff       	call   80103890 <myproc>

  acquire(&ptable.lock);
80107e4d:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80107e50:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);
80107e52:	68 60 3d 11 80       	push   $0x80113d60
80107e57:	e8 a4 c9 ff ff       	call   80104800 <acquire>

  if(share <= 0){
80107e5c:	83 c4 10             	add    $0x10,%esp
80107e5f:	85 f6                	test   %esi,%esi
80107e61:	7e 55                	jle    80107eb8 <set_cpu_share+0x78>
80107e63:	a1 74 b4 10 80       	mov    0x8010b474,%eax
80107e68:	29 f0                	sub    %esi,%eax
    }
    release(&ptable.lock);
    return 0;
  }

  if(curproc->stype == STRIDE)
80107e6a:	83 7b 70 02          	cmpl   $0x2,0x70(%ebx)
80107e6e:	74 40                	je     80107eb0 <set_cpu_share+0x70>
    new = mlfq.share + curproc->share - share;
  else
    new = mlfq.share - share;

  if(new < 20){
80107e70:	83 f8 13             	cmp    $0x13,%eax
80107e73:	76 7b                	jbe    80107ef0 <set_cpu_share+0xb0>
    release(&ptable.lock);
    return -1;
  }

  mlfq.share = new;
80107e75:	a3 74 b4 10 80       	mov    %eax,0x8010b474
  curproc->stype = STRIDE;
  curproc->qlev = 0;
  curproc->share = share;
  curproc->pass = mlfq.pass;
80107e7a:	a1 78 b4 10 80       	mov    0x8010b478,%eax
  curproc->stype = STRIDE;
80107e7f:	c7 43 70 02 00 00 00 	movl   $0x2,0x70(%ebx)
  curproc->qlev = 0;
80107e86:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
  curproc->share = share;
80107e8d:	89 73 7c             	mov    %esi,0x7c(%ebx)
  curproc->pass = mlfq.pass;
80107e90:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)

  release(&ptable.lock);
80107e96:	83 ec 0c             	sub    $0xc,%esp
80107e99:	68 60 3d 11 80       	push   $0x80113d60
80107e9e:	e8 1d ca ff ff       	call   801048c0 <release>
  return 0;
80107ea3:	83 c4 10             	add    $0x10,%esp
80107ea6:	31 c0                	xor    %eax,%eax
}
80107ea8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107eab:	5b                   	pop    %ebx
80107eac:	5e                   	pop    %esi
80107ead:	5d                   	pop    %ebp
80107eae:	c3                   	ret    
80107eaf:	90                   	nop
    new = mlfq.share + curproc->share - share;
80107eb0:	03 43 7c             	add    0x7c(%ebx),%eax
80107eb3:	eb bb                	jmp    80107e70 <set_cpu_share+0x30>
80107eb5:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->stype == STRIDE){
80107eb8:	83 7b 70 02          	cmpl   $0x2,0x70(%ebx)
80107ebc:	75 d8                	jne    80107e96 <set_cpu_share+0x56>
      mlfq.share += curproc->share;
80107ebe:	8b 43 7c             	mov    0x7c(%ebx),%eax
      curproc->stype = MLFQ;
80107ec1:	c7 43 70 01 00 00 00 	movl   $0x1,0x70(%ebx)
      mlfq.share += curproc->share;
80107ec8:	01 05 74 b4 10 80    	add    %eax,0x8010b474
      curproc->qlev = HQLEV;
80107ece:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
      curproc->share = 0;
80107ed5:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
      curproc->pass = 0;
80107edc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80107ee3:	00 00 00 
80107ee6:	eb ae                	jmp    80107e96 <set_cpu_share+0x56>
80107ee8:	90                   	nop
80107ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80107ef0:	83 ec 0c             	sub    $0xc,%esp
80107ef3:	68 60 3d 11 80       	push   $0x80113d60
80107ef8:	e8 c3 c9 ff ff       	call   801048c0 <release>
    return -1;
80107efd:	83 c4 10             	add    $0x10,%esp
80107f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f05:	eb a1                	jmp    80107ea8 <set_cpu_share+0x68>
80107f07:	66 90                	xchg   %ax,%ax
80107f09:	66 90                	xchg   %ax,%ax
80107f0b:	66 90                	xchg   %ax,%ax
80107f0d:	66 90                	xchg   %ax,%ax
80107f0f:	90                   	nop

80107f10 <allocthd>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
struct thread *
allocthd(struct proc *p)
{
80107f10:	55                   	push   %ebp
80107f11:	89 e5                	mov    %esp,%ebp
80107f13:	53                   	push   %ebx
  struct thread *t;
  char *sp;

  acquire(&ptable.lock);

  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80107f14:	bb 94 60 11 80       	mov    $0x80116094,%ebx
{
80107f19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80107f1c:	68 60 3d 11 80       	push   $0x80113d60
80107f21:	e8 da c8 ff ff       	call   80104800 <acquire>
80107f26:	83 c4 10             	add    $0x10,%esp
80107f29:	eb 10                	jmp    80107f3b <allocthd+0x2b>
80107f2b:	90                   	nop
80107f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80107f30:	83 c3 20             	add    $0x20,%ebx
80107f33:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
80107f39:	73 7d                	jae    80107fb8 <allocthd+0xa8>
    if(t->state == UNUSED)
80107f3b:	8b 43 08             	mov    0x8(%ebx),%eax
80107f3e:	85 c0                	test   %eax,%eax
80107f40:	75 ee                	jne    80107f30 <allocthd+0x20>
  release(&ptable.lock);
  return 0;

found:
  t->state = EMBRYO;
  t->tid = nexttid++;
80107f42:	a1 84 b4 10 80       	mov    0x8010b484,%eax

  release(&ptable.lock);
80107f47:	83 ec 0c             	sub    $0xc,%esp
  t->state = EMBRYO;
80107f4a:	c7 43 08 02 00 00 00 	movl   $0x2,0x8(%ebx)
  t->tid = nexttid++;
80107f51:	8d 50 01             	lea    0x1(%eax),%edx
80107f54:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&ptable.lock);
80107f57:	68 60 3d 11 80       	push   $0x80113d60
  t->tid = nexttid++;
80107f5c:	89 15 84 b4 10 80    	mov    %edx,0x8010b484
  release(&ptable.lock);
80107f62:	e8 59 c9 ff ff       	call   801048c0 <release>

  // Allocate kernel stack.
  if((t->kstack = kalloc()) == 0){
80107f67:	e8 34 a6 ff ff       	call   801025a0 <kalloc>
80107f6c:	83 c4 10             	add    $0x10,%esp
80107f6f:	85 c0                	test   %eax,%eax
80107f71:	89 43 04             	mov    %eax,0x4(%ebx)
80107f74:	74 5b                	je     80107fd1 <allocthd+0xc1>
  }

  sp = t->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *t->tf;
80107f76:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *t->context;
  t->context = (struct context*)sp;
  memset(t->context, 0, sizeof *t->context);
80107f7c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *t->context;
80107f7f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *t->tf;
80107f84:	89 53 14             	mov    %edx,0x14(%ebx)
  *(uint*)sp = (uint)trapret;
80107f87:	c7 40 14 af 5e 10 80 	movl   $0x80105eaf,0x14(%eax)
  t->context = (struct context*)sp;
80107f8e:	89 43 18             	mov    %eax,0x18(%ebx)
  memset(t->context, 0, sizeof *t->context);
80107f91:	6a 14                	push   $0x14
80107f93:	6a 00                	push   $0x0
80107f95:	50                   	push   %eax
80107f96:	e8 75 c9 ff ff       	call   80104910 <memset>
  t->context->eip = (uint)forkret;
80107f9b:	8b 43 18             	mov    0x18(%ebx),%eax

  t->mp = p;

  return t;
80107f9e:	83 c4 10             	add    $0x10,%esp
  t->context->eip = (uint)forkret;
80107fa1:	c7 40 10 b0 3c 10 80 	movl   $0x80103cb0,0x10(%eax)
  t->mp = p;
80107fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80107fab:	89 43 10             	mov    %eax,0x10(%ebx)
}
80107fae:	89 d8                	mov    %ebx,%eax
80107fb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107fb3:	c9                   	leave  
80107fb4:	c3                   	ret    
80107fb5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80107fb8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80107fbb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80107fbd:	68 60 3d 11 80       	push   $0x80113d60
80107fc2:	e8 f9 c8 ff ff       	call   801048c0 <release>
}
80107fc7:	89 d8                	mov    %ebx,%eax
  return 0;
80107fc9:	83 c4 10             	add    $0x10,%esp
}
80107fcc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107fcf:	c9                   	leave  
80107fd0:	c3                   	ret    
    t->state = UNUSED;
80107fd1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return 0;
80107fd8:	31 db                	xor    %ebx,%ebx
80107fda:	eb d2                	jmp    80107fae <allocthd+0x9e>
80107fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107fe0 <allthdexit>:

int
allthdexit(void)
{
80107fe0:	55                   	push   %ebp
80107fe1:	89 e5                	mov    %esp,%ebp
80107fe3:	57                   	push   %edi
80107fe4:	56                   	push   %esi
80107fe5:	53                   	push   %ebx
80107fe6:	83 ec 1c             	sub    $0x1c,%esp
  int havethds;
  struct thread *t;
  struct proc *curproc = myproc();
80107fe9:	e8 a2 b8 ff ff       	call   80103890 <myproc>
80107fee:	89 c7                	mov    %eax,%edi
  struct thread *curthd = mythd();
80107ff0:	e8 cb b8 ff ff       	call   801038c0 <mythd>
80107ff5:	89 c6                	mov    %eax,%esi

  if(curproc->exited)
80107ff7:	8b 47 18             	mov    0x18(%edi),%eax
80107ffa:	85 c0                	test   %eax,%eax
80107ffc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107fff:	0f 85 be 00 00 00    	jne    801080c3 <allthdexit+0xe3>
    return -1;

  curproc->exited = 1;
80108005:	c7 47 18 01 00 00 00 	movl   $0x1,0x18(%edi)
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
8010800c:	bb 94 60 11 80       	mov    $0x80116094,%ebx
80108011:	eb 10                	jmp    80108023 <allthdexit+0x43>
80108013:	90                   	nop
80108014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108018:	83 c3 20             	add    $0x20,%ebx
8010801b:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
80108021:	73 2d                	jae    80108050 <allthdexit+0x70>
    if(t->mp == curproc && t->state == SLEEPING)
80108023:	39 7b 10             	cmp    %edi,0x10(%ebx)
80108026:	75 f0                	jne    80108018 <allthdexit+0x38>
80108028:	83 7b 08 03          	cmpl   $0x3,0x8(%ebx)
8010802c:	75 ea                	jne    80108018 <allthdexit+0x38>
      setstate(curproc, t, RUNNABLE);
8010802e:	83 ec 04             	sub    $0x4,%esp
80108031:	6a 05                	push   $0x5
80108033:	53                   	push   %ebx
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80108034:	83 c3 20             	add    $0x20,%ebx
      setstate(curproc, t, RUNNABLE);
80108037:	57                   	push   %edi
80108038:	e8 b3 b8 ff ff       	call   801038f0 <setstate>
8010803d:	83 c4 10             	add    $0x10,%esp
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80108040:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
80108046:	72 db                	jb     80108023 <allthdexit+0x43>
80108048:	90                   	nop
80108049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(;;){
    havethds = 0;
    for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++){
80108050:	ba 94 60 11 80       	mov    $0x80116094,%edx
80108055:	eb 14                	jmp    8010806b <allthdexit+0x8b>
80108057:	89 f6                	mov    %esi,%esi
80108059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108060:	83 c2 20             	add    $0x20,%edx
80108063:	81 fa 94 80 11 80    	cmp    $0x80118094,%edx
80108069:	73 2d                	jae    80108098 <allthdexit+0xb8>
      if(t == curthd)
8010806b:	39 d6                	cmp    %edx,%esi
8010806d:	74 f1                	je     80108060 <allthdexit+0x80>
        continue;
      if(t->mp == curproc && t->state != ZOMBIE){
8010806f:	39 7a 10             	cmp    %edi,0x10(%edx)
80108072:	75 ec                	jne    80108060 <allthdexit+0x80>
80108074:	83 7a 08 01          	cmpl   $0x1,0x8(%edx)
80108078:	74 e6                	je     80108060 <allthdexit+0x80>
      }
    }

    if(!havethds)
      break;
    if(curproc->killed){
8010807a:	8b 47 14             	mov    0x14(%edi),%eax
8010807d:	85 c0                	test   %eax,%eax
8010807f:	75 29                	jne    801080aa <allthdexit+0xca>
      curproc->exited = 0;
      return -1;
    }
    sleep(curproc, &ptable.lock);
80108081:	83 ec 08             	sub    $0x8,%esp
80108084:	68 60 3d 11 80       	push   $0x80113d60
80108089:	57                   	push   %edi
8010808a:	e8 71 bc ff ff       	call   80103d00 <sleep>
    havethds = 0;
8010808f:	83 c4 10             	add    $0x10,%esp
80108092:	eb bc                	jmp    80108050 <allthdexit+0x70>
80108094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  curproc->exited = 0;
80108098:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
  return 0;
}
8010809f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080a5:	5b                   	pop    %ebx
801080a6:	5e                   	pop    %esi
801080a7:	5f                   	pop    %edi
801080a8:	5d                   	pop    %ebp
801080a9:	c3                   	ret    
      curproc->exited = 0;
801080aa:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
      return -1;
801080b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
}
801080b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080be:	5b                   	pop    %ebx
801080bf:	5e                   	pop    %esi
801080c0:	5f                   	pop    %edi
801080c1:	5d                   	pop    %ebp
801080c2:	c3                   	ret    
    return -1;
801080c3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
801080ca:	eb d3                	jmp    8010809f <allthdexit+0xbf>
801080cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801080d0 <thread_create>:

// Create thread
int
thread_create(thread_t *thread, void *(start_routine) (void*), void *arg)
{
801080d0:	55                   	push   %ebp
801080d1:	89 e5                	mov    %esp,%ebp
801080d3:	57                   	push   %edi
801080d4:	56                   	push   %esi
801080d5:	53                   	push   %ebx
801080d6:	83 ec 2c             	sub    $0x2c,%esp
  uint sp, ustack[2];
  struct thread *nth;
  struct proc *curproc = myproc();
801080d9:	e8 b2 b7 ff ff       	call   80103890 <myproc>
801080de:	89 c7                	mov    %eax,%edi
801080e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  struct thread *curthd = mythd();
801080e3:	e8 d8 b7 ff ff       	call   801038c0 <mythd>

  if ((nth = allocthd(curproc)) == 0)
801080e8:	83 ec 0c             	sub    $0xc,%esp
  struct thread *curthd = mythd();
801080eb:	89 c6                	mov    %eax,%esi
  if ((nth = allocthd(curproc)) == 0)
801080ed:	57                   	push   %edi
801080ee:	e8 1d fe ff ff       	call   80107f10 <allocthd>
801080f3:	83 c4 10             	add    $0x10,%esp
801080f6:	85 c0                	test   %eax,%eax
801080f8:	0f 84 d2 00 00 00    	je     801081d0 <thread_create+0x100>
    return -1;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  if ((sp = ualloc(curproc)) == 0){
801080fe:	83 ec 0c             	sub    $0xc,%esp
80108101:	89 c3                	mov    %eax,%ebx
80108103:	57                   	push   %edi
80108104:	e8 97 f6 ff ff       	call   801077a0 <ualloc>
80108109:	83 c4 10             	add    $0x10,%esp
8010810c:	85 c0                	test   %eax,%eax
8010810e:	0f 84 94 00 00 00    	je     801081a8 <thread_create+0xd8>
  }
  nth->usp = sp;

  // Push argument in ustack.
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = (uint)arg;
80108114:	8b 55 10             	mov    0x10(%ebp),%edx
  nth->usp = sp;
80108117:	89 03                	mov    %eax,(%ebx)

  sp -= 8;
  if(copyout(curproc->pgdir, sp, ustack, 8) < 0){
80108119:	6a 08                	push   $0x8
  ustack[0] = 0xffffffff;  // fake return PC
8010811b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  ustack[1] = (uint)arg;
80108122:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  sp -= 8;
80108125:	8d 50 f8             	lea    -0x8(%eax),%edx
  if(copyout(curproc->pgdir, sp, ustack, 8) < 0){
80108128:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010812b:	50                   	push   %eax
8010812c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010812f:	52                   	push   %edx
80108130:	89 55 d0             	mov    %edx,-0x30(%ebp)
80108133:	ff 70 04             	pushl  0x4(%eax)
80108136:	e8 c5 f5 ff ff       	call   80107700 <copyout>
8010813b:	83 c4 10             	add    $0x10,%esp
8010813e:	85 c0                	test   %eax,%eax
80108140:	8b 55 d0             	mov    -0x30(%ebp),%edx
80108143:	0f 88 97 00 00 00    	js     801081e0 <thread_create+0x110>
    nth->usp = 0;
    nth->state = UNUSED;
    return -1;
  }

  *nth->tf = *curthd->tf;
80108149:	8b 76 14             	mov    0x14(%esi),%esi
8010814c:	8b 7b 14             	mov    0x14(%ebx),%edi
8010814f:	b9 13 00 00 00       	mov    $0x13,%ecx
80108154:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  nth->tf->eip = (uint)start_routine;  // function
80108156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  nth->tf->esp = sp;

  *thread = (thread_t)nth->tid;

  acquire(&ptable.lock);
80108159:	83 ec 0c             	sub    $0xc,%esp
  nth->tf->eip = (uint)start_routine;  // function
8010815c:	8b 43 14             	mov    0x14(%ebx),%eax
8010815f:	89 48 38             	mov    %ecx,0x38(%eax)
  nth->tf->esp = sp;
80108162:	8b 43 14             	mov    0x14(%ebx),%eax
80108165:	89 50 44             	mov    %edx,0x44(%eax)
  *thread = (thread_t)nth->tid;
80108168:	8b 45 08             	mov    0x8(%ebp),%eax
8010816b:	8b 53 0c             	mov    0xc(%ebx),%edx
8010816e:	89 10                	mov    %edx,(%eax)
  acquire(&ptable.lock);
80108170:	68 60 3d 11 80       	push   $0x80113d60
80108175:	e8 86 c6 ff ff       	call   80104800 <acquire>

  nth->state = RUNNABLE;
  curproc->state = RUNNABLE;
8010817a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  nth->state = RUNNABLE;
8010817d:	c7 43 08 05 00 00 00 	movl   $0x5,0x8(%ebx)
  curproc->state = RUNNABLE;
80108184:	c7 40 08 05 00 00 00 	movl   $0x5,0x8(%eax)

  release(&ptable.lock);
8010818b:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80108192:	e8 29 c7 ff ff       	call   801048c0 <release>
  return 0;
80108197:	83 c4 10             	add    $0x10,%esp
8010819a:	31 c0                	xor    %eax,%eax
}
8010819c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010819f:	5b                   	pop    %ebx
801081a0:	5e                   	pop    %esi
801081a1:	5f                   	pop    %edi
801081a2:	5d                   	pop    %ebp
801081a3:	c3                   	ret    
801081a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(nth->kstack);
801081a8:	83 ec 0c             	sub    $0xc,%esp
801081ab:	ff 73 04             	pushl  0x4(%ebx)
801081ae:	e8 3d a2 ff ff       	call   801023f0 <kfree>
    nth->kstack = 0;
801081b3:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    nth->state = UNUSED;
801081ba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801081c1:	83 c4 10             	add    $0x10,%esp
801081c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081c9:	eb d1                	jmp    8010819c <thread_create+0xcc>
801081cb:	90                   	nop
801081cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801081d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081d5:	eb c5                	jmp    8010819c <thread_create+0xcc>
801081d7:	89 f6                	mov    %esi,%esi
801081d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kfree(nth->kstack);
801081e0:	83 ec 0c             	sub    $0xc,%esp
801081e3:	ff 73 04             	pushl  0x4(%ebx)
801081e6:	e8 05 a2 ff ff       	call   801023f0 <kfree>
    ufree(curproc, nth->usp);
801081eb:	58                   	pop    %eax
801081ec:	5a                   	pop    %edx
801081ed:	ff 33                	pushl  (%ebx)
801081ef:	ff 75 d4             	pushl  -0x2c(%ebp)
801081f2:	e8 39 f6 ff ff       	call   80107830 <ufree>
    nth->kstack = 0;
801081f7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    nth->usp = 0;
801081fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    return -1;
80108204:	83 c4 10             	add    $0x10,%esp
    nth->state = UNUSED;
80108207:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
8010820e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108213:	eb 87                	jmp    8010819c <thread_create+0xcc>
80108215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108220 <thread_exit>:

// thread exit
void
thread_exit(void *retval)
{
80108220:	55                   	push   %ebp
80108221:	89 e5                	mov    %esp,%ebp
80108223:	56                   	push   %esi
80108224:	53                   	push   %ebx
  int havethds;
  struct thread *t;
  struct proc *curproc = myproc();
80108225:	e8 66 b6 ff ff       	call   80103890 <myproc>
8010822a:	89 c3                	mov    %eax,%ebx
  struct thread *curthd = mythd();
8010822c:	e8 8f b6 ff ff       	call   801038c0 <mythd>

  acquire(&ptable.lock);
80108231:	83 ec 0c             	sub    $0xc,%esp
  struct thread *curthd = mythd();
80108234:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80108236:	68 60 3d 11 80       	push   $0x80113d60
8010823b:	e8 c0 c5 ff ff       	call   80104800 <acquire>
80108240:	83 c4 10             	add    $0x10,%esp
  havethds = 0;
  for(t = ptable.thread; t < &ptable.thread[NTHREAD]; t++)
80108243:	ba 94 60 11 80       	mov    $0x80116094,%edx
80108248:	eb 11                	jmp    8010825b <thread_exit+0x3b>
8010824a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108250:	83 c2 20             	add    $0x20,%edx
80108253:	81 fa 94 80 11 80    	cmp    $0x80118094,%edx
80108259:	73 5b                	jae    801082b6 <thread_exit+0x96>
    if(t->mp == curproc && t != curthd)
8010825b:	39 5a 10             	cmp    %ebx,0x10(%edx)
8010825e:	75 f0                	jne    80108250 <thread_exit+0x30>
80108260:	39 d6                	cmp    %edx,%esi
80108262:	74 ec                	je     80108250 <thread_exit+0x30>
      if(t->state > ZOMBIE){
80108264:	83 7a 08 01          	cmpl   $0x1,0x8(%edx)
80108268:	76 e6                	jbe    80108250 <thread_exit+0x30>
        havethds = 1;
        break;
      }
  release(&ptable.lock);
8010826a:	83 ec 0c             	sub    $0xc,%esp
8010826d:	68 60 3d 11 80       	push   $0x80113d60
80108272:	e8 49 c6 ff ff       	call   801048c0 <release>
80108277:	83 c4 10             	add    $0x10,%esp

  if(!havethds)
    exit();

  // Store result in eax.
  curthd->tf->eax = (uint)retval;
8010827a:	8b 55 08             	mov    0x8(%ebp),%edx
8010827d:	8b 46 14             	mov    0x14(%esi),%eax

  acquire(&ptable.lock);
80108280:	83 ec 0c             	sub    $0xc,%esp
  curthd->tf->eax = (uint)retval;
80108283:	89 50 1c             	mov    %edx,0x1c(%eax)
  acquire(&ptable.lock);
80108286:	68 60 3d 11 80       	push   $0x80113d60
8010828b:	e8 70 c5 ff ff       	call   80104800 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curthd->mp);
80108290:	58                   	pop    %eax
80108291:	ff 76 10             	pushl  0x10(%esi)
80108294:	e8 07 bd ff ff       	call   80103fa0 <wakeup1>

  // Jump into the scheduler, never to return.
  setstate(curproc, curthd, ZOMBIE);
80108299:	83 c4 0c             	add    $0xc,%esp
8010829c:	6a 01                	push   $0x1
8010829e:	56                   	push   %esi
8010829f:	53                   	push   %ebx
801082a0:	e8 4b b6 ff ff       	call   801038f0 <setstate>
  sched();
801082a5:	e8 b6 f9 ff ff       	call   80107c60 <sched>
  panic("zombie thread_exit");
801082aa:	c7 04 24 a5 8e 10 80 	movl   $0x80108ea5,(%esp)
801082b1:	e8 ca 80 ff ff       	call   80100380 <panic>
  release(&ptable.lock);
801082b6:	83 ec 0c             	sub    $0xc,%esp
801082b9:	68 60 3d 11 80       	push   $0x80113d60
801082be:	e8 fd c5 ff ff       	call   801048c0 <release>
    exit();
801082c3:	e8 38 bd ff ff       	call   80104000 <exit>
801082c8:	83 c4 10             	add    $0x10,%esp
801082cb:	eb ad                	jmp    8010827a <thread_exit+0x5a>
801082cd:	8d 76 00             	lea    0x0(%esi),%esi

801082d0 <thread_join>:
}

int
thread_join(thread_t thread, void **retval)
{
801082d0:	55                   	push   %ebp
801082d1:	89 e5                	mov    %esp,%ebp
801082d3:	57                   	push   %edi
801082d4:	56                   	push   %esi
801082d5:	53                   	push   %ebx
801082d6:	83 ec 0c             	sub    $0xc,%esp
801082d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int havethds;
  struct proc *curproc = myproc();
801082dc:	e8 af b5 ff ff       	call   80103890 <myproc>
  struct thread *t;
  
  acquire(&ptable.lock);
801082e1:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801082e4:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801082e6:	68 60 3d 11 80       	push   $0x80113d60
801082eb:	e8 10 c5 ff ff       	call   80104800 <acquire>
801082f0:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited thread.
    havethds = 0;
    for (t = ptable.thread; t < &ptable.thread[NTHREAD]; t++){
801082f3:	bb 94 60 11 80       	mov    $0x80116094,%ebx
    havethds = 0;
801082f8:	31 c0                	xor    %eax,%eax
801082fa:	eb 0f                	jmp    8010830b <thread_join+0x3b>
801082fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (t = ptable.thread; t < &ptable.thread[NTHREAD]; t++){
80108300:	83 c3 20             	add    $0x20,%ebx
80108303:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
80108309:	73 20                	jae    8010832b <thread_join+0x5b>
      if(t->mp != curproc || t->tid != (int)thread)
8010830b:	39 73 10             	cmp    %esi,0x10(%ebx)
8010830e:	75 f0                	jne    80108300 <thread_join+0x30>
80108310:	39 7b 0c             	cmp    %edi,0xc(%ebx)
80108313:	75 eb                	jne    80108300 <thread_join+0x30>
        continue;
      havethds = 1;
      if(t->state == ZOMBIE){
80108315:	83 7b 08 01          	cmpl   $0x1,0x8(%ebx)
80108319:	74 45                	je     80108360 <thread_join+0x90>
    for (t = ptable.thread; t < &ptable.thread[NTHREAD]; t++){
8010831b:	83 c3 20             	add    $0x20,%ebx
      havethds = 1;
8010831e:	b8 01 00 00 00       	mov    $0x1,%eax
    for (t = ptable.thread; t < &ptable.thread[NTHREAD]; t++){
80108323:	81 fb 94 80 11 80    	cmp    $0x80118094,%ebx
80108329:	72 e0                	jb     8010830b <thread_join+0x3b>
        return 0;
      }
    }

    // No point waiting if we don't have any thread.
    if(!havethds || myproc()->killed || myproc()->exited){
8010832b:	85 c0                	test   %eax,%eax
8010832d:	0f 84 88 00 00 00    	je     801083bb <thread_join+0xeb>
80108333:	e8 58 b5 ff ff       	call   80103890 <myproc>
80108338:	8b 50 14             	mov    0x14(%eax),%edx
8010833b:	85 d2                	test   %edx,%edx
8010833d:	75 7c                	jne    801083bb <thread_join+0xeb>
8010833f:	e8 4c b5 ff ff       	call   80103890 <myproc>
80108344:	8b 40 18             	mov    0x18(%eax),%eax
80108347:	85 c0                	test   %eax,%eax
80108349:	75 70                	jne    801083bb <thread_join+0xeb>
      release(&ptable.lock);
      return -1;
    }

    // Wait for thread to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010834b:	83 ec 08             	sub    $0x8,%esp
8010834e:	68 60 3d 11 80       	push   $0x80113d60
80108353:	56                   	push   %esi
80108354:	e8 a7 b9 ff ff       	call   80103d00 <sleep>
    havethds = 0;
80108359:	83 c4 10             	add    $0x10,%esp
8010835c:	eb 95                	jmp    801082f3 <thread_join+0x23>
8010835e:	66 90                	xchg   %ax,%ax
        *retval = (void*)t->tf->eax;
80108360:	8b 43 14             	mov    0x14(%ebx),%eax
        kfree(t->kstack);
80108363:	83 ec 0c             	sub    $0xc,%esp
        *retval = (void*)t->tf->eax;
80108366:	8b 50 1c             	mov    0x1c(%eax),%edx
80108369:	8b 45 0c             	mov    0xc(%ebp),%eax
8010836c:	89 10                	mov    %edx,(%eax)
        kfree(t->kstack);
8010836e:	ff 73 04             	pushl  0x4(%ebx)
80108371:	e8 7a a0 ff ff       	call   801023f0 <kfree>
        ufree(curproc, t->usp);
80108376:	59                   	pop    %ecx
80108377:	5f                   	pop    %edi
80108378:	ff 33                	pushl  (%ebx)
8010837a:	56                   	push   %esi
8010837b:	e8 b0 f4 ff ff       	call   80107830 <ufree>
        release(&ptable.lock);
80108380:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
        t->kstack = 0;
80108387:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        t->usp = 0;
8010838e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        t->state = UNUSED;
80108394:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        t->tid = 0;
8010839b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        t->mp = 0;
801083a2:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801083a9:	e8 12 c5 ff ff       	call   801048c0 <release>
        return 0;
801083ae:	83 c4 10             	add    $0x10,%esp
801083b1:	31 c0                	xor    %eax,%eax
  }
}
801083b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083b6:	5b                   	pop    %ebx
801083b7:	5e                   	pop    %esi
801083b8:	5f                   	pop    %edi
801083b9:	5d                   	pop    %ebp
801083ba:	c3                   	ret    
      release(&ptable.lock);
801083bb:	83 ec 0c             	sub    $0xc,%esp
801083be:	68 60 3d 11 80       	push   $0x80113d60
801083c3:	e8 f8 c4 ff ff       	call   801048c0 <release>
      return -1;
801083c8:	83 c4 10             	add    $0x10,%esp
801083cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083d0:	eb e1                	jmp    801083b3 <thread_join+0xe3>
801083d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801083e0 <nextthd>:

struct thread *
nextthd(struct proc *p)
{
801083e0:	55                   	push   %ebp
801083e1:	89 e5                	mov    %esp,%ebp
801083e3:	53                   	push   %ebx
      }

      if(t == p->pin)
        return 0;
    }
    t = ptable.thread;
801083e4:	bb 94 60 11 80       	mov    $0x80116094,%ebx
{
801083e9:	8b 55 08             	mov    0x8(%ebp),%edx
  t = p->pin + 1;
801083ec:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801083f2:	8d 41 20             	lea    0x20(%ecx),%eax
801083f5:	eb 10                	jmp    80108407 <nextthd+0x27>
801083f7:	89 f6                	mov    %esi,%esi
801083f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(t == p->pin)
80108400:	39 c1                	cmp    %eax,%ecx
80108402:	74 24                	je     80108428 <nextthd+0x48>
    for(;t < &ptable.thread[NTHREAD]; t++){
80108404:	83 c0 20             	add    $0x20,%eax
    t = ptable.thread;
80108407:	3d 94 80 11 80       	cmp    $0x80118094,%eax
8010840c:	0f 43 c3             	cmovae %ebx,%eax
      if(t->mp == p && t->state == RUNNABLE){
8010840f:	39 50 10             	cmp    %edx,0x10(%eax)
80108412:	75 ec                	jne    80108400 <nextthd+0x20>
80108414:	83 78 08 05          	cmpl   $0x5,0x8(%eax)
80108418:	75 e6                	jne    80108400 <nextthd+0x20>
        p->pin = t;
8010841a:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  }
}
80108420:	5b                   	pop    %ebx
80108421:	5d                   	pop    %ebp
80108422:	c3                   	ret    
80108423:	90                   	nop
80108424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return 0;
80108428:	31 c0                	xor    %eax,%eax
}
8010842a:	5b                   	pop    %ebx
8010842b:	5d                   	pop    %ebp
8010842c:	c3                   	ret    
