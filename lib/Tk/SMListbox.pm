=head1 NAME

Tk::SMListbox - Sortable Multicolumn Listbox with arrows in headers 
	indicating sort order.

=head1 SYNOPSIS

use Tk::MListbox;

$ml = $parent->SMListbox (<options>);

=head1 DESCRIPTION

SMListbox is a derivitive of MListbox that adds optional tiny up and 
down arrow graphics to columns in the SMListbox that the data is 
currently sorted on indicating ascending and/or descending order.

Sorting is done by clicking on one of the column headings in the 
widget. The first click will sort the data with the selected column as 
key, a new click will reverse the sort order.

=head1 Examples

my $table = $w->Scrolled('SMListbox'

		-scrollbars => 'se', 

		-height => 12,

		-relief => 'sunken',

		-sortable => 1,

		-selectmode => 'extended',

		-showallsortcolumns => 1,

		-takefocus => 1,

		-borderwidth => 1,

		-columns => [

			[-text => 'D', -width => 3, -comparecommand => sub { $_[1] cmp $_[0]}],

			[-text => 'Name', -width => 25,],

			[-text => 'Perm.', -width => 10,],

			[-text => 'Owner:Group', -width => 14,],

			[-text => 'Size', -width => 8, -comparecommand => sub { $_[1] <=> $_[0]}],

			[-text => 'Date/Time', -width => 15,],

		]

		)->pack(

				-expand => 'yes',

		);

=head1 AUTHOR

Jim Turner

MListbox authors:  Hans Jorgen Helgesen, hans_helgesen@hotmail.com (from March 2000: hans.helgesen@novit.no)

=head1 SEE ALSO

L<Tk::MListbox> L<Tk::Listbox>

=head1 STANDARD OPTIONS

B<-background> B<-foreground> B<-relief> B<-takefocus> B<-borderwidth>   B<-heigh>
B<-selectbackground> B<-cursor> B<-highlightbackground> B<-selectborderwidth>
B<-xscrollcommand> B<-exportselection> B<-highlightcolor> B<-selectforeground>
B<-yscrollcommand> B<-font> B<-highlightthickness> B<-setgrid>

=head1 WIDGET SPECIFIC OPTIONS

=over 4

=item -columns => I<list>

Defines the columns in the widget. Each element in the list 
describes a column. See the B<COLUMNS> section below.

=item -configurecommand => I<callback>

The -configurecommand callback will be called whenever the layout of the
widget has changed due to user interaction. That is, the user changes the
width of a column by dragging the separator, or moves a column by dragging
the column header. 

This option is useful if the application wants to store the widget layout 
for later retrieval. The widget layout can be obtained by the callback
by calling the method columnPackInfo().

=item -moveable => I<boolean>

A value of B<1> indicates that it is okay for the user to move
the columns by dragging the column headers. B<0> disables this
function.

Default: B<1>

=item -resizeable => I<boolean>

A value of B<1> indicates that it is okay for the user to resize
the columns by dragging the column separators. B<0> disables 
this function.

Default: B<1>

Note that you can also specify -resizeable on a column
by column basis. See the B<COLUMNS> section below.

=item -selectmode => I<string>

Should be "single", "browse", "multiple", or "extended".

Default is "browse". See L<Tk::Listbox>.

=item -separatorcolor => I<string>

Specifies the color of the separator lines 
(the vertical lines that separates the columns). 

Default: B<black>

Note that you can also specify -separatorcolor on a column
by column basis. See the B<COLUMNS> section below.

=item -separatorwidth => I<integer>

Specifies the width in pixels of the separator lines 
(the vertical lines that separates the columns). 

Default: B<1>

Note that you can also specify -separatorwidth on a column
by column basis. See the B<COLUMNS> section below.

=item -sortable => I<boolean>

A value of B<1> indicates that it is okay for the user to sort
the data by clicking column headings. B<0> disables this function.

Default: B<1>

Note that you can also specify -sortable on a column
by column basis. See I<COLUMNS> below.

=back

=head1 MLISTBOX COLUMN CONFIGURATION

The MListbox widget is a collection of I<MLColumn> widgets. 
Each MLColumn contains a Listbox, a heading and the separator bar.
The columns are created and maintained through the -columns 
option or the column methods of the widget. The columns are indexed
from 0 and up. Initially, column 0 is the leftmost column of the
widget. The column indices B<are not changed> when the columns
are moved or hidden. The only ways to change the column indices 
are to call columnInsert(), columnDelete() or configure(-column).

Each column has its own set of options which might be passed to 
MListbox::configure(-columns), MListbox::insert(),
MListbox::columnConfigure() or MLColumn::configure().

The following code snippets are all equal:

1.  $ml=$mw->MListbox(-columns=>[[-text=>'Heading1',
                                  -sortable=>0],
                                 [-text=>'Heading2']]);

2.  $ml=$mw->MListbox;
    $ml->columnInsert(0,-text=>'Heading1', -sortable=>0);
    $ml->columnInsert(0,-text=>'Heading2');

3.  $ml=$mw->MListbox;
    $c=$ml->columnInsert(0,-text=>'Heading1');
    $ml->columnInsert(0,-text=>'Heading2');
    $c->configure(-sortable=>0);

4.  $ml=$mw->MListbox;
    $ml->columnInsert(0,-text=>'Heading1');
    $ml->columnInsert(0,-text=>'Heading2');
    $ml->columnConfigure(0,-sortable=>0);

(See the columnConfigure() method below for details on column options).

All column methods expects one or two column indices as arguments.
The column indices might be an integer (between 0 and the number
of columns minus one), 'end' for the last column, or a reference
to the MLColumn widget (obtained by calling MListbox->columnGet() 
or by storing the return value from MListbox->columnInsert()).

=head1 WIDGET METHODS

=over 4

=item $ml->compound([left|right|top|bottom])

Gets / sets the side of the column header that the 
ascending / descending arrow is to appear (left, right, top, 
bottom), default is "right".

=item $ml->getSortOrder() returns an array that is in the same format 

Accepted by the $smListBox->sort method.  The 1st element is 
either true for descending sort, false for assending.  
Subsequent elements represent the column indices of one or 
more columns by which the data is sorted.

=item $ml->showallsortcolumns([1|0])

Gets or sets whether a sort direction arrow is to be displayed 
on each column involved in the sorting or just the 1st 
(primary sort).  Default is 0 (false) - show arrow only on the 
primary sort column.

=item $ml->bindColumns(I<sequence>,I<callback>)

Adds the binding to all column headers in the widget. See the section
BINDING EVENTS TO MLISTBOX below.

=item $ml->bindRows(I<sequence>,I<callback>)

Adds the binding to all listboxes in the widget. See the section
BINDING EVENTS TO MLISTBOX below.

=item $ml->bindSeparators(I<sequence>,I<callback>)

Adds the binding to all separators in the widget. See the section
BINDING EVENTS TO MLISTBOX below.

=back

=head2 COLUMN METHODS

(Methods for accessing and manipulating individual columns
in the MListbox widget)

=over 4

=item $ml->columnConfigure(I<index>,I<option>=>I<value>...)

Set option values for a specific column.
Equal to $ml->columnGet(I<index>)->configure(...).

The following column options are supported:

=item

-comparecommand => I<callback>

Specifies a callback to use when sorting the MListbox with this
column as key. The callback will be called with two scalar arguments,
each a value from this particular column. The callback should 
return an integer less than, equal to, or greater than 0, depending
on how the tow arguments are ordered. If for example the column
should be sorted by numerical value:

    -comparecommand => sub { $_[0] <=> $_[1]}

The default is to sort the columns alphabetically.

=item

-text => I<string>

Specifies the text to be used in the heading button of the column.

=item

-resizeable => I<boolean>

A value of B<1> indicates that it is okay for the user to resize
this column by dragging the separator. B<0> disables this function.

Default: B<1>

=item

-separatorcolor => I<string>

Specifies the color of the separator line, default is B<black>.

=item

-separatorwidth => I<integer>

Specifies the width of the separator line in pixels. Default is B<1>.

=item

-sortable => I<boolean>

A value of B<1> indicates that it is okay for the user to sort
the data by clicking this column's heading. B<0> disables this 
function.

Default: B<1>

=item $ml->columnDelete(I<first>,I<last>)

If I<last> is omitted, deletes column I<first>. If I<last> is
specified, deletes all columns from I<first> to I<last>, inclusive.

All previous column indices greater than I<last> (or I<first> if
I<last> is omitted) are decremented by the number of columns 
deleted.

=item $ml->columnGet(I<first>,I<last>)

If I<last> is not specified, returns the MLColumn widget specified by I<first>.
If both I<first> and I<last> are specified, returns an array containing all
columns from I<first> to I<last>.

=item $ml->columnHide(I<first>,I<last>)

If I<last> is omitted, hides column I<first>. If I<last> is
specified, hides all columns from I<first> to I<last>, inclusive.

Hiding a column is equal to calling $ml->columnGet(I<index>)->packForget. 
The column is B<not> deleted, all data are still available, 
and the column indices remain the same.

See also the columnShow() method below.

=item $ml->columnIndex(I<index>)

Returns an integer index for the column specifed by I<index>.

=item $ml->columnInsert(I<index>,I<option>=>I<value>...)

Creates a new column in the MListbox widget. The column will 
get the index specified by I<index>. If I<index> is 'end', the
new column's index will be one more than the previous highest
column index.

If column I<index> exists, the new column will be placed
to the B<left> of this column. All previous column indices 
equal to or greater than I<index> will be incremented by one.

Returns the newly created MLColumn widget.

(See the columnConfigure() method above for details on column options).

=item $ml->columnPack(I<array>)

Repacks all columns in the MListbox widget according to the 
specification in I<array>. Each element in I<array> is a string
on the format B<index:width>. I<index> is a column index, I<width> 
defines the columns width in pixels (may be omitted). The columns 
are packed left to right in the order specified by by I<array>.
Columns not specified in I<array> will be hidden.

This method is most useful if used together with the 
columnPackInfo() method.

=item $ml->columnPackInfo

Returns an array describing the current layout of the MListbox
widget. Each element of the array is a string on the format
B<index:width> (see columnPack() above). Only indices of columns that 
are currently shown (not hidden) will be returned. The first element
in the returned array represents the leftmost column.

This method may be used in conjunction with columnPack() to save
and restore the column configuration. 

=item $ml->columnShow(I<index>,I<option>=>I<value>)

Shows a hidden column (see the columnHide() method above). 
The column to show is specified by I<index>.

By default, the column is pack'ed at the rigthmost end of the
MListbox widget. This might be overridden by specifying one of
the following options:

=item 

-after => I<index>

Place the column B<after> (to the right of) the column specified
by I<index>.

=item 

-before => I<index>

Place the column B<before> (to the left of) the column specified
by I<index>.

=back

=head2 ROW METHODS

(Methods for accessing and manipulating rows of data)

Many of the methods for MListbox take one or more indices as 
arguments. See L<Tk::Listbox> for a description of row indices.

=over 4

=item $ml->delete(I<first>,I<last>)

Deletes one or more row elements of the MListbox. I<First> and I<last>
are indices specifying the first and last elements in the range to 
delete. If I<last> isn't specified it defaults to I<first>, 
i.e. a single element is deleted. 

=item $ml->get(I<first>,I<last>)

If I<last> is omitted, returns the content of the MListbox row
indicated by I<first>. If I<last> is specified, the command returns
a list whose elements are all of the listbox rows between 
I<first> and I<last>.

The returned elements are all array references. The referenced
arrays contains one element for each column of the MListbox.

=item $ml->getRow(I<index>)

In scalar context, returns the value of column 0 in the MListbox
row specified by I<index>. In list context, returns the content
of all columns in the row as an array.

This method is provided for convenience, since retrieving a single
row with the get() method might produce some ugly code.

The following two code snippets are equal:

   1. @row=$ml->getRow(0);

   2. @row=@{($ml->get(0))[0]};


=item $ml->sort(I<descending>, I<columnindex>...)

Sorts the content of the MListbox. If I<descending> is a B<true> 
value, the sort order will be descending. The default is ascending
sort.

If I<columnindex> is specified, the sort will be done with the 
specified column as key. You can specify as many I<columnindex>
arguments as you wish. Sorting is done on the first column, then
on the second, etc...

The default is to sort the data on all columns of the listbox, 
with column 0 as the first sort key, column 1 as the second, etc.

=back

=head1 OTHER LISTBOX METHODS

Most other Tk::Listbox methods works for the MListbox widget.  This
includes the methods activate, cget, curselection, index, nearest, see,
selectionXXX, size, xview, yview.

See L<Tk::Listbox>

=head1 BINDING EVENTS TO SMLISTBOX

Calling $ml->bind(...) probably makes little sense, since the call does not
specify whether the binding should apply to the listbox, the header button 
or the separator line between each column.

In stead of the ordinary bind, the following methods should be used:

=over 4

=item $ml->bind(I<sequence>,I<callback>)

Synonym for $ml->bindRows(I<sequence>,I<callback>).

=item $ml->bindRows(I<sequence>,I<callback>)

Synonym for $ml->bindSubwidgets('listbox',I<sequence>,I<callback>)

=item $ml->bindColumns(I<sequence>,I<callback>)

Synonym for $ml->bindSubwidgets('heading',I<sequence>,I<callback>)

=item $ml->bindSeparators(I<sequence>,I<callback>)

Synonym for $ml->bindSubwidgets('separator',I<sequence>,I<callback>)

=item $ml->bindSubwidgets(I<subwidget>,I<sequence>,I<callback>)

Adds the binding specified by I<sequence> and I<callback> to all subwidgets
of the given type (should be 'listbox', 'heading' or 'separator'). 

The binding is stored in the widget, and if you create a new column 
by calling $ml->columnInsert(), all bindings created by $ml->bindSubwidgets()
are automatically copied to the new column.

The callback is called with the MListbox widget as first argument, and
the index of the column where the event occured as the second argument.

NOTE that $ml->bindSubwidgets() does not support all of Tk's callback formats.
The following are supported:

     \&subname
     sub { code }
     [ \&subname, arguments...]
     [ sub { code }, arguments...]

If I<sequence> is undefined, then the return value is a list whose elements 
are all the sequences for which there exist bindings for I<subwidget>.

If I<sequence> is specified without I<callback>, then the callback currently 
bound to sequence is returned, or an empty string is returned if there is no
binding for sequence.

If I<sequence> is specified, and I<callback> is an empty string, then the
current binding for sequence is destroyed, leaving sequence unbound. 
An empty string is returned.

An empty string is returned in all other cases.

=cut

## SMListbox Version 1.11 (Dec 2008)
##
## SMListbox is a derivitive of MListbox that adds optional tiny up and 
## down arrow graphics to columns in the SMListbox that the data is 
## currently sorted on indicating ascending and/or descending order.
##
## SMListbox adds 3 new methods:  "compound", getSortOrder and 
## "showallsortcolumns":
##
## $smListBox->compound gets / sets the side of the column header that the 
## ascending / descending arrow is to appear (left, right, top, bottom), 
## default is "right".
##
## $smListBox->getSortOrder returns an array that is in the same format 
## accepted by the $smListBox->sort method.  The 1st element is either 
## true for descending sort, false for assending.  Subsequent elements 
## represent the column indices of one or more columns by which the data 
## is sorted.
##
## $smListBox->showallsortcolumns gets or sets whether a sort direction 
## arrow is to be displayed on each column involved in the sorting or just 
## the 1st (primary sort).  Default is 0 (false) - show arrow only on the 
## primary sort column.
##
##############################################################################
## MListbox Version 1.11 (26 Dec 2001)
##
## Original Author: Hans J. Helgesen, Dec 1999  
## Maintainer: Rob Seegel (versions 1.10+)
##
## This version is a maintenance release of Hans' MListbox widget.
## I have tried to avoid adding too many new features and just ensure 
## that the existing ones work properly.
## 
## Please post feedback to comp.lang.perl.tk or email to RobSeegel@aol.com
##
## This module contains four classes. Of the four MListbox is
## is the only one intended for standalone use, the other three:
## CListbox, MLColumn, HButton are accessible as Subwidgets, but
## not intended to be used in any other way other than as 
## components of MListbox
##
##############################################################################
## CListbox is similar to an ordinary listbox, but with the following 
## differences:
## - Calls an -updatecommand whenever something happens to it.
## - Horizontal scanning is disabled, calls -xscancommand to let parent widget
##   handle this.

{
    package Tk::CListbox;
    use base qw(Tk::Derived Tk::Listbox);

    Tk::Widget->Construct('CListbox');
    
    sub Populate {
        my ($w, $args) = @_;
        $w->SUPER::Populate($args);
        $w->ConfigSpecs(
            -background    => [qw/SELF background Background/, $Tk::NORMAL_BG],
            -foreground    => [qw/SELF foreground Foreground/, $Tk::NORMAL_FG],
            -updatecommand => ['CALLBACK'],
            -xscancommand  => ['CALLBACK']
        );
    }
   
    sub selectionSet {
        my ($w) = @_;
        $w->Callback(-updatecommand=>$w->can('Tk::Listbox::selectionSet'),@_);
    }
    sub selectionClear {
        my ($w)=@_;
        $w->Callback(-updatecommand=>$w->can('Tk::Listbox::selectionClear'),@_);
    }
    sub selectionAnchor {
        my ($w)=@_;
        $w->Callback(-updatecommand=>$w->can('Tk::Listbox::selectionAnchor'),@_);
    }
    sub activate {
        my ($w)=@_;
        $w->Callback(-updatecommand=>$w->can('Tk::Listbox::activate'),@_);
    }
    sub see {
        my ($w)=@_;
        $w->Callback(-updatecommand=>$w->can('Tk::Listbox::see'),@_);
    }
    sub yview {
        my ($w)=@_;
        $w->Callback(-updatecommand=>$w->can('Tk::Listbox::yview'),@_);     
    }
    sub scan {
        my ($w,$type,$x,$y) = @_;
        # Disable horizontal scanning.
        if ($type eq 'mark') {
	    $w->{'_scanmark_x'} = $x;
        }
        $w->Callback(-updatecommand=>$w->can('Tk::Listbox::scan'),
	    $w, $type, $w->{'_scanmark_x'}, $y
        );
        $w->Callback(-xscancommand=>$type,$x);
    }
}

##############################################################################
## HButton is like an ordinary Button, but with an addition option:
## -pixelwidth
## The new configure method makes sure the pixelwidth is always retained.
{
    package Tk::HButton;
    use base qw(Tk::Derived Tk::Button);   
    Tk::Widget->Construct('HButton');
    
    sub Populate {
        my ($w, $args) = @_;
        $w->SUPER::Populate($args);
        $w->ConfigSpecs(
            -pixelwidth => ['PASSIVE'],
            -bitmap => [qw/SELF bitmap bitmap/, 'noarrow'],
            -compound => [qw/SELF compound compound/, 'right'],
            -background    => [qw/SELF background Background/, $Tk::NORMAL_BG],
            -foreground    => [qw/SELF foreground Foreground/, $Tk::NORMAL_FG]
	);
    }

    sub configure {
        my $w = shift;
        my (@ret) = $w->SUPER::configure(@_);
        unless (@ret) {
	    if (defined(my $pixels = $w->cget('-pixelwidth'))) {
	        $w->GeometryRequest($pixels,$w->reqheight);
	      }
	}
        return @ret;
    }
}

###############################################################################
## MLColumn implements a single column in the MListbox. MLColumn is a composite
## containing a heading (an HButton), a listbox (CListbox) and a frame which  
## frame which serves as a draggable separator 
{
    package Tk::MLColumn;
    use base qw(Tk::Frame);
    Tk::Widget->Construct('MLColumn');
    
    sub Populate {
	my ($w, $args) = @_;
	$w->SUPER::Populate($args);
       
        ## MLColumn Components
        ## $sep - separator - Frame
        ## $hdr - heading    - HButton
        ## $f   - frame     - Frame	
        ## $lb  - listbox   - CListbox

	my $sep = $w->Component(
            Frame   => 'separator',
            -height => 1
        )->pack(qw/-side right -fill y -anchor w/);

	$sep->bind( "<B1-Motion>", 
            [$w=>'adjustMotion']);
	$sep->bind("<ButtonRelease-1>", 
            [$w=>'Callback','-configurecommand']);

	my $f = $w->Component(
            Frame => "frame"
	)->pack(qw/-side left -anchor e -fill y -expand 1/);
	
	my $hdr = $f->HButton(
            -takefocus=>0,
	    -padx=>0,
	    -width=>1,
	    -borderwidth=>2,
            -highlightthickness=>0
        )->pack(qw/-side top -anchor n -fill x/);
	$w->Advertise("heading" => $hdr);
	
	my $lb = $f->CListbox(
	    -highlightthickness=>0,
	    -relief=>'flat',
	    -bd=>0,
	    -exportselection=>0,
	    -takefocus=>0
        )->pack(qw/-side top -anchor n -expand 1 -fill both/);
	$w->Advertise("listbox" => $lb);
   	
	$w->Delegates (DEFAULT => $lb);
	


	$w->ConfigSpecs(
	    -background     => [[$f, $hdr, $lb], 
                                qw/background Background/, $Tk::NORMAL_BG],
            -comparecommand => ['CALLBACK', undef, undef,
                sub{$_[0] cmp $_[1]}],
	    -configurecommand => ['CALLBACK'],

	    -font           => [[$hdr, $lb], qw/font Font/, undef],
            -foreground     => [[$hdr, $lb],
                                qw/foreground Foreground/, $Tk::NORMAL_FG],
	    -separatorwidth => [{-width => $sep}, 
                                qw/separatorWidth Separator 1/],
	    -separatorcolor => [{-background => $sep}, 
                                qw/sepaatorColor Separator black/],
	    -resizeable     => [qw/METHOD resizeable Resizeable 1/],
	    -sortable       => [qw/PASSIVE sortable Sortable 1/],
	    -text           => [$hdr],
	    -compound       => [[$hdr], 'compound', 'compound', 'right'],
	    -updatecommand  => [$lb],
	    -textwidth      => [{-width => [$lb, $hdr]}],
	    DEFAULT         => [$lb]
	);
	$w->ConfigAlias(
	    -comparecmd => '-comparecommand',
	    -width      => '-textwidth'
        );

    }

######################################################################
## MLColumn Configuration methods (call via configure/cget). 
######################################################################

    sub resizeable {
        my ($w, $value) = @_;
        return $w->{Configure}{-resizeable} unless
            defined $value;
        $w->Subwidget("separator")->configure(
            -cursor => ($value ? 'sb_h_double_arrow' : 'xterm')
        );
    }

    sub compare {
        my ($w,$a,$b) = @_;
        $w->Callback(-comparecommand => $a, $b);
    }

    sub setWidth {
        my ($w, $pixels) = @_;
        $pixels -= $w->Subwidget("separator")->width;
        return 
            unless $pixels >= 0;
    
        $w->Subwidget("listbox")->GeometryRequest(
            $pixels,$w->Subwidget("listbox")->height);
        $w->Subwidget("heading")->configure(-pixelwidth=>$pixels);
    }

######################################################################
## MLColumn Private  methods (Do not depend on these methods being present)
######################################################################

## Adjust size of column.
    sub adjustMotion {
        my ($w) = @_;    
        $w->setWidth($w->pointerx - $w->rootx);
    }

} ## END PRELOADING OF MLColumn

######################################################################
## Package: Tk::SMListbox
## Purpose: Multicolumn widget used to display tabular data
##          This widget has the ability to sort data by column,
##          hide/show columns, and the ability to change the order
##          of columns on the fly

package Tk::SMListbox;
use strict;
use Carp;
use vars qw($VERSION);
$VERSION = '1.11';

use Tk;

## Overidden Scrolled method to suit the purposes of MListbox
## I want -columns to be configured LAST no matter what.
## I know full well that I'm overriding the Scrolled method
## and I don't need a warning broadcasting the fact.

no warnings;

sub Tk::Widget::Scrolled {
    my ($parent, $kind, %args) = @_;
 
    my $colAR;
    $colAR = delete $args{'-columns'} if $kind eq "SMListbox";

    ## Find args that are Frame create time args
    my @args = Tk::Frame->CreateArgs($parent,\%args);
    my $name = delete $args{'Name'};
    push(@args,'Name' => $name) if (defined $name);
    my $cw = $parent->Frame(@args);
    @args = ();

    ## Now remove any args that Frame can handle
    foreach my $k ('-scrollbars',map($_->[0],$cw->configure)) {
        push(@args,$k,delete($args{$k})) if (exists $args{$k})
    }
    ## Anything else must be for target widget - pass at widget create time
    my $w  = $cw->$kind(%args);

    ## Now re-set %args to be ones Frame can handle
    ## RCS NOTE: I've also slightly modified the ConfigSpecs
    %args = @args;
    $cw->ConfigSpecs(
        '-scrollbars' => [qw/METHOD   scrollbars Scrollbars se/],
        '-background' => [$w, qw/background Background/, undef],
        '-foreground' => [$w, qw/foreground Foreground/, undef],
    );
    $cw->AddScrollbars($w);
    $cw->Default("\L$kind" => $w);
    $cw->Delegates('bind' => $w, 'bindtags' => $w, 'menu' => $w);
    $cw->ConfigDefault(\%args);
    $cw->configure(%args);
    $cw->configure(-columns => $colAR) if $colAR;
    return $cw;
}
use warnings;

require Tk::Pane;
use base qw(Tk::Frame);
Tk::Widget->Construct('SMListbox');

sub ClassInit {
    my ($class,$mw) = @_;
    $mw->bind($class,'<Configure>',['_yscrollCallback']);
    $mw->bind($class,'<Down>',['_upDown',1]);
    $mw->bind($class,'<Up>',  ['_upDown',-1]);
    $mw->bind($class,'<Shift-Up>',  ['_extendUpDown',-1]);
    $mw->bind($class,'<Shift-Down>',['_extendUpDown',1]);
    $mw->bind($class,'<Control-Home>','_cntrlHome');
    $mw->bind($class,'<Control-End>','_cntrlEnd');
    $mw->bind($class,'<Shift-Control-Home>',['_dataExtend',0]);
    $mw->bind($class,'<Shift-Control-End>',['_dataExtend',Ev('index', 'end')]);
    $mw->bind($class,'<Control-slash>','_selectAll');
    $mw->bind($class,'<Control-backslash>','_deselectAll');

	my $downArrowBits = pack("b10"x10,
			"..........",
			"..........",
			"..........",
			".#########",
			"..#######.",
			"...#####..",
			"....###...",
			".....#....",
			"..........",
			".........."
			);
	$mw->DefineBitmap('downarrow' => 10,10, $downArrowBits);
	my $upArrowBits = pack("b10"x10,
			"..........",
			"..........",
			"..........",
			".....#....",
			"....###...",
			"...#####..",
			"..#######.",
			".#########",
			"..........",
			".........."
			);
	$mw->DefineBitmap('uparrow' => 10,10, $upArrowBits);
	my $noArrowBits = pack("b10"x10,
			"..........",
			"..........",
			"..........",
			"..........",
			"..........",
			"..........",
			"..........",
			"..........",
			"..........",
			".........."
			);
	$mw->DefineBitmap('noarrow' => 10,10, $noArrowBits);

}

## Do some slightly tricky stuff: The -columns option, if called is
## guaranteed to be confiugred last of all the options submitted.
## NOTE: The args hash is cleared out if a columns option is sent
## so that all the options won't be reconfigured again immediately
## after this method finishes. ALso, if Scrolled is called, then
## the -columns option will never make it down to this level so 

sub InitObject {
    my ($w, $args) = @_;

    my $colAR = delete $args->{'-columns'};
    $w->Populate($args);
    $w->ConfigDefault($args);
    if ($colAR) {
        $w->configure(%$args);
        $w->configure(-columns => $colAR);
        %$args = ();
    }
}

sub Populate {
    my ($w, $args) = @_;

#    $w->SUPER::Populate($args);   

    $w->{'_columns'} = [];          ## Array of MLColumn objects 
    $w->{'_sortcol'} = -1;          ## Column used for sorting
    $w->{'_sortcolumns'} = [];
    $w->{'_sort_descending'} = 0;   ## Flag for ascending/desc. sort order
    $w->{'_top'} = 0;
    $w->{'_bottom'} = 0;

    my $pane = $w->Component(
        Pane => "pane",
        -sticky => 'nsew'
    )->pack(-expand=>1,-fill=>'both');

    my $font;
    if ($Tk::platform eq 'MSWin32') {
        $font = "{MS Sans Serif} 8";
    } else {
        $font = "Helvetica -12 bold";
    }

    $w->ConfigSpecs(
        -background        => [qw/METHOD background Background/, 
		              $TK::NORMAL_BG ],
        -columns           => [qw/METHOD/],
	-configurecommand  => [qw/CALLBACK/],
        -font              => [qw/METHOD font Font/, $font],
        -foreground        => [qw/METHOD foreground Foreground/,
                              $Tk::NORMAL_FG ],
	-height            => [qw/METHOD height Height 10/],
	-moveable          => [qw/PASSIVE moveable Moveable 1/],
        -resizeable        => [qw/METHOD resizeable Resizeable 1/],
        -selectbackground  => [qw/METHOD selectBackground Background/, 
			      $Tk::SELECT_BG],
        -selectborderwidth => [qw/METHOD selectBorderwidth Borderwidth 1/],
        -selectforeground  => [qw/METHOD selectForeground Foreground/,
			      $Tk::SELECT_FG],
        -selectmode        => [qw/METHOD selectMode Mode browse/],
        -compound        => [qw/METHOD compound compound right/],
        -showallsortcolumns      => [qw/METHOD showallsortcolumns showallsortcolumns 0/],
        -separatorcolor    => [qw/METHOD separatorColor Separator black/],
        -separatorwidth    => [qw/METHOD separatorWidth Separator 1/], 
	-sortable          => [qw/METHOD sortable Sortable 1/],
        -takefocus         => [qw/PASSIVE takeFocus Focus 1/],
        -textwidth         => [qw/METHOD textWidth Width 10/],
        -width             => [qw/METHOD width Width/, undef],
      	-xscrollcommand    => [$pane],
	-yscrollcommand    => ['CALLBACK'],  
    );

    $w->ConfigAlias(
        -selectbg => "-selectbackground",
        -selectbd => "-selectborderwidth",
	-selectfg => "-selectforeground",
        -sepcolor => "-separatorcolor",
        -sepwidth => "-separatorwidth",
    );
}

sub getSortOrder {   #JWT:  ADDED THIS METHOD TO FETCH HOW THE LIST IS SORTED!
	my $w = shift;

	my @l = scalar(@{$w->{'_sortcolumns'}}) ? @{$w->{'_sortcolumns'}} : (0);
	return ($w->{'_sort_descending'}||0, @l);
}

######################################################################
## Configuration methods (call via configure). 
######################################################################

## Background is a slightly tricky option, this option would be a 
## great candidate for "DESCENDANTS", except for the separator subwidget in
## each column set by separatorcolor which I'd prefer not to set in such
## a clumsy way. All other background colors are fair game, but I'd like 
## to leave open the possibility for other exceptions such as separator. 
## Besides I prefer that composite subwidgets manage their own component parts
## as much as possible.

sub background { 
    my ($w, $val) = @_;
    return $w->{Configure}{'-background'}
        unless $val;
  
    ## Ensure that the base Frame, pane and columns (if any) get set
    Tk::configure($w, "-background", $val);
    $w->Subwidget("pane")->configure("-background", $val);
    $w->_configureColumns("-background", $val);
}

## columns needs to be called last during creation time if set and I 
## went to a great deal of trouble to guarantee this. The reason
## being is that it needs to use many of the other configurations to
## use as defaults for columns, and the ability to override any of them
## for individual columns. If these options (that the columns override)
## were called afterwards, then the reverse would happen. All the default
## would override the individually specified options.

sub columns {
    my ($w, $vAR) = @_;
    return $w->{Configure}{'-columns'} unless
        defined $vAR;
    $w->columnDelete(0, 'end');
    map {$w->columnInsert('end', @$_)} @$vAR; 
}

sub font              { shift->_configureColumns('-font', @_) }
sub foreground        { shift->_configureColumns('-foreground', @_) }
sub height            { shift->_configureColumns('-height', @_) }
sub resizeable        { shift->_configureColumns('-resizeable', @_) }
sub selectbackground  { shift->_configureColumns('-selectbackground', @_) }
sub selectborderwidth { shift->_configureColumns('-selectborderwidth', @_) }
sub selectforeground  { shift->_configureColumns('-selectforeground', @_) }
sub selectmode        { shift->_configureColumns('-selectmode', @_) }
sub compound {    #JWT:  ADDED THIS METHOD TO ALLOW USER TO DYNAMICALLY OVERWRITE WHERE THE SORT ARROW IMAGE DISPLAYS.
	my $w = shift;
	if (scalar(@_) > 0)
	{
		$w->_configureColumns('-compound', @_);
		$w->{'-compound'} = $_[0];
	}
	else
	{
		return $w->{'-compound'};
	}
}
sub showallsortcolumns {    #JWT:  ADDED THIS METHOD TO ALLOW USER TO DYNAMICALLY OVERWRITE WHERE THE SORT ARROW IMAGE DISPLAYS.
	my $w = shift;
	if (scalar(@_) > 0)
	{
		$w->{'-showallsortcolumns'} = $_[0];
	}
	else
	{
		return $w->{'-showallsortcolumns'};
	}
}
sub separatorcolor    { shift->_configureColumns('-separatorcolor', @_ ) }
sub separatorwidth    { shift->_configureColumns('-separatorwidth', @_ ) }
sub sortable          { shift->_configureColumns('-sortable', @_) }
sub textwidth         { shift->_configureColumns('-textwidth', @_) }

sub width {
    my ($w, $v) = @_;

    return $w->{Configure}{'-width'} unless defined $v;
    if ($v == 0) {
        $w->afterIdle(['_setWidth', $w]);
    } else {
        $w->Subwidget('pane')->configure(-width => $v);
    }
}

######################################################################
## Private  methods (Do not depend on these methods being present)
##
## For all methods which have _firstVisible, the method is delegated 
## to the first visible (packed) Listbox
######################################################################

## This is the main callback that is bound to the subwidgets
## when using any of the public bind methods, The defined 
## defined callback ($cb) is called from within it

sub _bindCallback {
    my ($w, $cb, $sw, $ci, $yCoord) = @_;

    my $iHR = { '-subwidget' => $sw, '-column' => $ci };
    if (defined($yCoord)) {
        $iHR->{'-row'} = $w->_getEntryFromY($sw, $yCoord);
    }
    if (ref $cb eq 'ARRAY') {
	my ($code,@args) = @$cb;
	return $w->$code($iHR, @args);
    } else {
	return $w->$cb($iHR);
    }
}

## bind subwidgets is used by other public bind methods to
## apply a callback to an event dequence of a particular subwidget 
## within each of the columns. Any defined callbacks are passed
## to the _bindCallback which is actually the callback that gets
## bound. 

sub _bindSubwidgets {
    my ($w,$subwidget,$sequence,$callback) = @_;
    my $col = 0;
    
    return (keys %{$w->{'_bindings'}->{$subwidget}})
        unless (defined $sequence);

    unless (defined $callback) {
	$callback = $w->{'_bindings'}->{$subwidget}->{$sequence};
	$callback = '' unless defined $callback;
	return $callback;
    }
    
    if ($callback eq '') {
	foreach (@{$w->{'_columns'}}) {
	    $_->Subwidget($subwidget)->Tk::bind($sequence,'');
	}
	delete $w->{'_bindings'}->{$subwidget}->{$sequence};
	return '';
    }
    my @args = ('_bindCallback', $callback);
    foreach (@{$w->{'_columns'}}) {
        my $sw = $_->Subwidget($subwidget);
        if ($sw->class ne "CListbox") {
	    $sw->Tk::bind($sequence, [$w => @args, $sw, $col++]);
	} else {
	    $sw->Tk::bind($sequence, [$w => @args, $sw, $col++, Ev('y')]);
        }
    }
    $w->{'_bindings'}->{$subwidget}->{$sequence} = $callback;
    return '';
}

## handles config options that should be propagated to all MLColumn 
## subwidgets. Using the DEFAULT setting in ConfigSpecs would be one 
## idea, but the pane subwidget is also a child, and Pane will not 
## be able to handle many of the options being passed to this method.

sub _configureColumns {
    my ($w, $option, $value) = @_;
    return $w->{Configure}{$option}
        unless $value;

    foreach (@{$w->{'_columns'}}) {
	$_->configure("$option" => $value);
    }
}

sub _cntrlEnd  { shift->_firstVisible->Cntrl_End; }

sub _cntrlHome { shift->_firstVisible->Cntrl_Home; }

sub _dataExtend {
    my ($w, $el) = @_;
    my $mode = $w->cget('-selectmode');
    if ($mode eq 'extended') {
        $w->activate($el);
        $w->see($el);
        if ($w->selectionIncludes('anchor')) {
            $w->_firstVisible->Motion($el)
        }
    } elsif ($mode eq 'multiple') {
        $w->activate($el);
        $w->see($el)
    }
}

sub _deselectAll {
    my $w = shift;
    if ($w->cget('-selectmode') ne 'browse') {
        $w->selectionClear(0, 'end');
    }
}

## implements sorting and dragging & drop of a column
sub _dragOrSort {
    my ($w, $c) = @_;
 
    unless ($w->cget('-moveable')) {
	if ($c->cget('-sortable')) {
	    $w->sort (undef, $c);
	}
	return;
    }
    
    my $h=$c->Subwidget("heading");  # The heading button of the column.
    
    my $start_mouse_x = $h->pointerx;
    my $y_pos = $h->rooty;  # This is constant through the whole operation.
    my $width = $h->width;
    my $left_limit = $w->rootx - 1;
    
    # Find the rightmost, visible column
    my $right_end = 0;
    foreach (@{$w->{'_columns'}}) {
	if ($_->rootx + $_->width > $right_end) {
	    $right_end = $_->rootx + $_->width;
	}
    }	    
    my $right_limit = $right_end + 1;
   
    # Create a "copy" of the heading button, put it in a toplevel that matches
    # the size of the button, put the toplevel on top of the button.
    my $tl=$w->Toplevel; 
    $tl->overrideredirect(1);
    $tl->geometry(sprintf("%dx%d+%d+%d",
			  $h->width, $h->height, $h->rootx, $y_pos));

    my $b=$tl->HButton
	(map{defined($_->[4]) ? ($_->[0]=>$_->[4]) : ()} $h->configure)
	    ->pack(-expand=>1,-fill=>'both');
    
    # Move the toplevel with the mouse (as long as Button-1 is down).
    $h->bind("<Motion>", sub {
	my $new_x = $h->rootx - ($start_mouse_x - $h->pointerx);
	unless ($new_x + $width/2 < $left_limit ||
		$new_x + $width/2 > $right_limit) 
	{
	    $tl->geometry(sprintf("+%d+%d",$new_x,$y_pos));
	}
    });

    $h->bind("<ButtonRelease-1>", sub {
	my $rootx = $tl->rootx;
	my $x = $rootx + ($tl->width/2);
	$tl->destroy;    # Don't need this anymore...
	$h->bind("<Motion>",'');  # Cancel binding

	if ($h->rootx == $rootx) {	
	    # Button NOT moved, sort the column....
	    if ($c->cget('-sortable')) {
		$w->sort(undef, $c);
	    }
	    return;
	}
		
	# Button moved.....
	# Decide where to put the column. If the center of the dragged 
	# button is on the left half of another heading, insert it -before 
	# the column, otherwise insert it -after the column.
	foreach (@{$w->{'_columns'}}) {
	    if ($_->ismapped) {
		my $left = $_->rootx;
		my $right = $left + $_->width;
		if ($left <= $x && $x <= $right) {
		    if ($x - $left < $right - $x) {
			$w->columnShow($c,-before=>$_);
		    } else {
			$w->columnShow($c,'-after'=>$_);
		    }
		    $w->update;
		    $w->Callback(-configurecommand => $w);
		}
	    }
	}
    });
}

sub _extendUpDown {
    my ($w, $amount) = @_;
    if ($w->cget('-selectmode') ne 'extended') {
        return;
    }
    $w->activate($w->index('active')+$amount);
    $w->see('active');
    $w->_motion($w->index('active'))
}

## Many of the methods in this package are very similar in that they
## delagate calls to the MLColumn widgets. Because widgets can be
## be moved around (repacked) and hidden (packForget), any
## one widget may not be the "best" to be delegating calls to. The
## _columns variable holds an array of the columns but the order of 
## this array does not correspond to the order in which they might 
## by displayed, therefore this method is used to return the first
## "visible" or packed MLColumn. RCS Note: It might be reasonable to
## make this a public method as it could conceivably useful to someone
## who might want to subclass this widget or use their own bindings.
sub _firstVisible {
    my $w = shift;
    foreach my $c (@{$w->{'_columns'}}) {
	return $c if $c->ismapped;
    }
    return $w->{'_columns'}->[0];
}

sub _getEntryFromY {
    my ($cw, $sw, $yCoord) = @_;
    my $nearest = $sw->nearest($yCoord);
 
    return $nearest
        if ($nearest < ($sw->size() - 1));
    
    my ($x, $y, $w, $h) = $sw->bbox($nearest);
    my $lastY = $y + $h;
    return -1 
        if ($yCoord > $lastY);
    return $nearest;
}

## Used to distribute method calls which would otherwise be called for
## for one CListbox (Within a column), Each CListbox is a modified 
## Listbox whose methods end up passing the code and arguments that need
## to be called to this method where they are invoked for each column
## It's an interesting, although complex, interaction and it's worth 
## tracing to follow the program flow.

sub _motion    { shift->_firstVisible->Motion(@_) }
sub _selectAll { shift->_firstVisible->SelectAll; }

sub _selectionUpdate {
    my ($w, $code, $l, @args) = @_;

    if (@args) {
	foreach (@{$w->{'_columns'}}) {
	    &$code($_->Subwidget("listbox"), @args);
	}
    } else {
	&$code($w->{'_columns'}->[0]->Subwidget("listbox"));
    }
}

## dynamically sets the width of the widget by calculating
## the width of each of the currently visible columns. 
## This is generally called during creation time when -width
## is set to 0.

sub _setWidth {
    my ($w) = shift;
    my $width = 0;
    foreach my $c (@{$w->{'_columns'}}) {
        my $lw = $c->Subwidget('heading')->reqwidth;
        my $sw = $c->Subwidget('separator')->reqwidth;
        $width += ($lw + $sw);
    }
    $w->Subwidget('pane')->configure(-width => $width);
}



sub _upDown { shift->_firstVisible->UpDown(@_) }

sub _yscrollCallback  {
    my ($w, $top, $bottom) = @_;

    unless ($w->cget(-yscrollcommand)) {
	return;
    }

    unless (defined($top)) {
	# Called internally
	my $c = $w->_firstVisible;
	if (Exists($c) && $c->ismapped){
	    ($top,$bottom) = $c->yview;
	} else {
	    ($top,$bottom) = (0,1);
	}
    } 
    
    if ($top != $w->{'_top'} || $bottom != $w->{'_bottom'}) {
	$w->Callback(-yscrollcommand=>$top,$bottom);
	$w->{'_top'} = $top;
	$w->{'_bottom'} = $bottom;
    }
}

######################################################################
## Exported (Public) methods (listed alphabetically)
######################################################################

## Activate a row
sub activate { shift->_firstVisible->activate(@_)}

sub bindColumns    {  shift->_bindSubwidgets('heading',@_) }
sub bindRows       {  shift->_bindSubwidgets('listbox',@_) }
sub bindSeparators {  shift->_bindSubwidgets('separator',@_) }

sub columnConfigure {
    my ($w, $index, %args) = @_;
    $w->columnGet($index)->configure(%args);
}

## Delete a column.
sub columnDelete {
    my ($w, $first, $last) = @_;

    for (my $i=$w->columnIndex($first); $i<=$w->columnIndex($last); $i++) {
	$w->columnGet($i)->destroy;
    }
    @{$w->{'_columns'}} = map{Exists($_) ? $_ : ()} @{$w->{'_columns'}};
}

sub columnGet {
    my ($w, $from, $to) = @_;
    if (defined($to)) {
	$from= $w->columnIndex($from);
	$to = $w->columnIndex($to);
	return @{$w->{'_columns'}}[$from..$to];
    } else {
	return $w->{'_columns'}->[$w->columnIndex($from)];
    }
}

sub columnHide {
    my ($w, $first, $last) = @_;
    $last = $first unless defined $last;

    for (my $i=$w->columnIndex($first); $i<=$w->columnIndex($last); $i++) {
	$w->columnGet($i)->packForget;
    }
}

## Converts a column index to a numeric index. $index might be a number,
## 'end' or a reference to a MLColumn widget (see columnGet). Note that
## the index return by this method may not match up with it's current
## visual location due to columns being moved around

sub columnIndex {    
    my ($w, $index, $after_end) = @_;

    if ($index eq 'end') {
	if (defined $after_end) {
	    return $#{$w->{'_columns'}} + 1;
	} else {
	    return $#{$w->{'_columns'}};
	}
    } 
    
    if (ref($index) eq "Tk::MLColumn") {
	foreach (0..$#{$w->{'_columns'}}) {
	    if ($index eq $w->{'_columns'}->[$_]) {
		return $_;
	    }
	}
    } 

    if ($index =~ m/^\s*(\d+)\s*$/) {
	return $1;
    }    
    croak "Invalid column index: $index\n";
}

## Insert a column. $index should be a number or 'end'. 
sub columnInsert {
    my ($w, $index, %args) = @_;
   
    $index = $w->columnIndex($index,1);
    my %opts = ();
    
    ## Copy these options from the megawidget.
    foreach (qw/-background -foreground -font -height 
        -resizeable -selectbackground -selectforeground 
        -selectborderwidth -selectmode -separatorcolor
        -separatorwidth -sortable -textwidth/) 
    {
	$opts{$_} = $w->cget($_) if defined $w->cget($_);
    }
    ## All options (and more) might be overridden by %args.
    map {$opts{$_} = $args{$_}} keys %args;
    
    my $c = $w->Subwidget("pane")->MLColumn(%opts, 
        -yscrollcommand  =>  [ $w => '_yscrollCallback'],
	-configurecommand => [ $w => 'Callback', '-configurecommand', $w],
	-xscancommand =>     [ $w => 'xscan' ],
	-updatecommand =>    [ $w => '_selectionUpdate']
    );
    
    ## RCS: Review this later - questionable implementation
    ## Fill the new column with empty values, making sure all columns have
    ## the same number of rows.
    unless (scalar(@{$w->{'_columns'}}) == 0) {
	foreach (1..$w->size) {
	    $c->insert('end','');
	}
    }  
    $c->Subwidget("heading")->bind("<Button-1>", [ $w => '_dragOrSort', $c]);
    $c->Subwidget("heading")->configure(-compound => $w->{'-compound'})  if ($w->{'-compound'});
    
    my $carr = $w->{'_columns'};
    splice(@$carr,$index,0,$c);

    ## Update the selection to also include the new column.
    map {$w->selectionSet($_, $_)} $w->curselection
        if $w->curselection;

    ## Copy all bindings that are created by calls to 
    ## bindRows, bindColumns and/or bindSeparators.
    ## RCS: check this out, on the next pass
    foreach my $subwidget (qw/listbox heading separator/) {
	foreach (keys %{$w->{'_bindings'}->{$subwidget}}) {
	    $c->Subwidget($subwidget)->Tk::bind($_, 
                [
                    $w => 'bindCallback', 
                    $w->{'_bindings'}->{$subwidget}->{$_},
                    $index
                ]
            );
	}
    }
    
    if (Tk::Exists($w->{'_columns'}->[$index+1])) {
	$w->columnShow($index, -before=>$index+1);
    } else {
	$w->columnShow($index);
    }
    return $c;
}

sub columnPack {
    my ($w, @packinfo) = @_;
    $w->columnHide(0,'end');
    foreach (@packinfo) {
	my ($index, $width) = split /:/;
	$w->columnShow ($index);
	if (defined($width) && $width =~ /^\d+$/) {
	    $w->columnGet($index)->setWidth($width)
	}
    }
}

sub columnPackInfo {
    my ($w) = @_;

    ## Widget needs to have an update call first, otherwise
    ## the method will not return anything if called prior to
    ## MainLoop - RCS

    $w->update;
    map {$w->columnIndex($_) . ':' . $_->width} 
       sort {$a->rootx <=> $b->rootx}
          map {$_->ismapped ? $_ : ()} @{$w->{'_columns'}};
}    

sub columnShow {
    my ($w, $index, %args) = @_;
    
    my $c = $w->columnGet($index);
    my @packopts = (-anchor=>'w',-side=>'left',-fill=>'both');
    if (defined($args{'-before'})) {
	push (@packopts, '-before'=>$w->columnGet($args{'-before'}));
    } elsif (defined($args{'-after'})) {
	push (@packopts, '-after'=>$w->columnGet($args{'-after'}));
    }
    $c->pack(@packopts);
}

sub curselection { shift->_firstVisible->curselection(@_)}

sub delete {
    my $w = shift;
    foreach (@{$w->{'_columns'}}) {
	my $saved_width = $_->width;
        $_->delete(@_);
	if ($_->ismapped) {
	    $_->setWidth($saved_width);
	}
    }
    $w->_yscrollCallback;
}
    
sub get {
    my @result = ();
    my ($colnum,$rownum) = (0,0);
    
    foreach (@{shift->{'_columns'}}) {
	my @coldata = $_->get(@_);
	$rownum = 0;
	map {$result[$rownum++][$colnum] = $_} @coldata;
	$colnum++;
    }
    @result;
}

sub getRow {
    my @result = map {$_->get(@_)} @{shift->{'_columns'}};
    if (wantarray) {
	@result;
    } else {
	$result[0];
    }
}
    
sub index { shift->_firstVisible->index(@_)}

sub insert {
    my ($w, $index, @data) = @_;
    my ($rownum, $colnum);
    
    my $rowcnt = $#data;
    
    # Insert data into one column at a time, calling $listbox->insert
    # ONCE for each column. (The first version of this widget call insert
    # once for each row in each column).
    # 
    foreach $colnum (0..$#{$w->{'_columns'}}) {	
	my $c = $w->{'_columns'}->[$colnum];
	
	# The listbox might get resized after insert/delete, which is a 
	# behaviour we don't like....
	my $saved_width = $c->width;

	my @coldata = ();

	foreach (0..$#data) {
	    if (defined($data[$_][$colnum])) {
		push @coldata, $data[$_][$colnum];
	    } else {
		push @coldata, '';
	    }
	}
	$c->insert($index,@coldata);
	
	if ($c->ismapped) {
	    # Restore saved width.
	    $c->setWidth($saved_width);
	} 
    }    
    $w->_yscrollCallback;
}

## These methods all delegate to the first visible column's
## Listbox. Refer to Listbox docs and description for _firstVisible

sub nearest           { shift->_firstVisible->nearest(@_)}
sub see               { shift->_firstVisible->see(@_)}
sub selectionAnchor   { shift->_firstVisible->selectionAnchor(@_)}
sub selectionClear    { shift->_firstVisible->selectionClear(@_)}
sub selectionIncludes { shift->_firstVisible->selectionIncludes(@_)}
sub selectionSet      { shift->_firstVisible->selectionSet(@_)}
sub size              { shift->_firstVisible->size(@_)}

sub sort {
    my ($w, $descending, @indexes) = @_;

    my @l = @{$w->{'_sortcolumns'}};
    foreach my $i (@l) {
      $w->{'_columns'}->[$i]->Subwidget("heading")->configure(-bitmap => 'noarrow');
    }

    # Hack to avoid problem with older Tk versions which do not support
    # the -recurse=>1 option.
    $w->Busy;   # This works always (but not very good...)
    Tk::catch {$w->Busy(-recurse=>1)};# This works on newer Tk versions,
                                      # harmless on old versions.
     
    @indexes = (0..$#{$w->{'_columns'}}) unless @indexes;

    # Convert all indexes to integers.
    map {$_=$w->columnIndex($_)} @indexes;
    # This works on Solaris, but not on Linux???
    # Store the -comparecommand for each row in a local array. In the sort,
    # the store command is called directly in stead of via the MLColumn
    # subwidget. This saves a lot of callbacks and function calls.
    #
    # my @cmp_subs = map {$_->cget(-comparecommand)} @{$w->{'_columns'}};
    
    # If sort order is not defined
    unless (defined $descending) {
	if ($#indexes == 0 &&
	    $w->{'_sortcol'} == $indexes[0] &&
	    $w->{'_sort_descending'} == 0)
	{
	    # Already sorted on this column, reverse sort order.
	    $descending = 1;
	} else {
	    $descending = 0;
	}
    }

    # To retain the selection after the sort we have to save information
    # about the current selection before the sort. Adds a dummy column
    # to the two dimensional data array, this last column will be true
    # for all rows that are currently selected.
    my $dummy_column = scalar(@{$w->{'_columns'}});

    my @data = $w->get(0,'end');
    foreach ($w->curselection) {
	$data[$_]->[$dummy_column] = 1;  # Selected...
    }
    
    @data = sort {
	local $^W = 0;
	foreach (@indexes) {
	    my $res = do {
		if ($descending) {
		    # Call via cmp_subs works fine on Solaris, but no
		    # on Linux. The column->compare method is much slower...
		    #
		    # &{$cmp_subs[$_]} ($b->[$_],$a->[$_]);
		    $w->{'_columns'}->[$_]->compare($b->[$_],$a->[$_]);
		} else {
		    # &{$cmp_subs[$_]} ($a->[$_],$b->[$_]);
		    $w->{'_columns'}->[$_]->compare($a->[$_],$b->[$_]);
		}
	    };
	    return $res if $res;
	}
	return 0;
    } @data;
        
    # Replace data with the new, sorted list.
    $w->delete(0,'end');
    $w->insert(0,@data);

    my @new_selection = ();
    foreach (0..$#data) {
	if ($data[$_]->[$dummy_column]) {
	    $w->selectionSet($_,$_);
	}
    }

    $w->{'_sortcol'} = $indexes[0];
    @{$w->{'_sortcolumns'}} = @indexes;
    $w->{'_sort_descending'} = $descending;
    
    $w->Unbusy; #(-recurse=>1);
    if ($w->{'-showallsortcolumns'}) {
      for (my $i=0;$i<=$#indexes;$i++) {   #UNCOMMENT TO SHOW ALL SORTED COLUMNS:
        $w->{'_columns'}->[$indexes[$i]]->Subwidget("heading")->configure(-bitmap => ($w->{'_sort_descending'} ? 'downarrow' : 'uparrow'));
      }
    } else {
      $w->{'_columns'}->[$indexes[0]]->Subwidget("heading")->configure(-bitmap => ($w->{'_sort_descending'} ? 'downarrow' : 'uparrow'));
    }
}

# Implements horizontal scanning. 
sub xscan {
    my ($w, $type, $x) = @_;

    if ($type eq 'dragto') {
	my $dist = $w->{'_scanmark_x'} - $w->pointerx;
	
	# Looks like there is a bug in Pane: If no -xscrollcommand
	# is defined, xview() fails. This is fixed by this hack:
	#
	my $p = $w->Subwidget("pane");
	unless (defined ($p->cget(-xscrollcommand))) {
	    $p->configure(-xscrollcommand => sub {});
	}
	$p->xview('scroll',$dist,'units');
    }
    $w->{'_scanmark_x'} = $w->pointerx;
}

sub xview { shift->Subwidget("pane")->xview(@_) }
sub yview { shift->_firstVisible->yview(@_)}

1;
__END__

















