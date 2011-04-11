DDUIBlocks
==========

Daniel Dickison [<danieldickison@gmail.com>][email]

[email]: danieldickison@gmail.com

About
-----

A collection of wrappers around various UIKit classes to give them blocks-based APIs.

The advantage of using blocks is that you can keep your event-handling logic closer to other related bits of code. For example, the `DDBlockAlert` class lets you add buttons along with the handler block, instead of having to create a separate method in a delegate that branches based on the clicked button index.

`DDBlockTableDelegate` is a `UITableViewDelegate` and `UITableViewDataSource` that lets you specify cell specs from which the various table cell bahaviors are derived.  This is in contrast to the "normal" way of having your data source method branch depending on the cell indexPath that is passed in.  The blocks-based API is particularly suited for tables which few but greatly varying cells, for example in a settings-type UI where each cell holds a different type of interactive UI element.  It is less suited for long, homogeneous lists as it creates a cell spec object for each row, which may be inefficient (however you can reuse the handler blocks, so it might not be so bad).

Usage
-----

Drag the DDUIBlocks directory to your Xcode project, and include them in your target build.  Then, in your source files, `#import "DDUIBlocks.h"`.

See the demo project for example usage.

Memory Management
-----------------

While the use of blocks simplifies many aspects of the API, it adds a major complication in terms of memory management.  Blocks used as handlers are copied to the heap when added as event handlers to the DDUIBlocks classes.  Furthermore, all blocks retain objects that are referenced in the block body.  So if your block refers to `self`, or the UI object that owns the block, it will create a retain cycle resulting in a memory leak.

The workaround is to use the `__block` modifier for any local variables to which your blocks refer.  You can assign `self` to another local variable (e.g. `__block id blockSelf`).  A local variable marked with `__block` will _not_ be retained by blocks.  As long as you can ensure that the block will never be called after your own objects have been disposed, you can use the `__block` modifier safely.  This condition should be generally true for use of DDUIBlocks classes because your parent object (e.g. the view controller) will "own" the DDUIBlocks object, which in turn "owns" the handler blocks.

For more info on blocks and retain cycles, see these links:

http://www.mikeash.com/pyblog/friday-qa-2010-04-30-dealing-with-retain-cycles.html
http://borkwarellc.wordpress.com/2010/09/06/block-retain-cycles/
http://stackoverflow.com/questions/4352561/retain-cycle-on-self-with-blocks
http://rentzsch.tumblr.com/post/3946232049/avoiding-retain-cycles-with-blocks

License
-------

Copyright (c) 2011, Daniel Dickison
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of Daniel Dickison nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
