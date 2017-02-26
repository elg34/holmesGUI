#!/usr/bin/perl -w
#
# A Holmes Game, awfully simple, written so that I may learn how to use Gtk2... this is getting old

use Gtk2 -init;
use strict;
use Glib qw(TRUE FALSE);
use Switch;

#the beginning
our $FILE = 'quothHolmes.txt';
open (FILE) or die "Can't open the file!";
my @incoming = <FILE>;
close (FILE);
my @answer = qw();
my @text = qw();
foreach my $var (@incoming){
	chomp($var);
	my @tem = split(/=/, $var);
	push(@answer, $tem[0]);
	push(@text, $tem[1]);
};
my $pic = 'holmesqueMan2.gif';
my $position;
my $content;
if(defined $ARGV[0]){
	$position = $ARGV[0];
	$content = $text[$ARGV[0]-1];
}else{$position = 0; $content = "You might want to ask for help.";};

#mainwindow
my $window = Gtk2::Window->new;
$window->signal_connect (delete_event => sub { Gtk2->main_quit });
$window->set_position('center');


#HBox
my $hbox = Gtk2::HBox->new(FALSE, 0);

#HBOX:image
my $picframe = Gtk2::Frame->new("London, April 8th 1894");
$picframe->set_border_width(5);
my $image = Gtk2::Image->new_from_file($pic);
$picframe->add($image);
$hbox->pack_start ($picframe, FALSE, FALSE, 4);

#HBOX:FRAME:VBox
my $frame = Gtk2::Frame->new("Welcome to 221b Baker Street!");
$frame->set_border_width(5);
my $vbox = Gtk2::VBox->new(FALSE, 5);

#HBOX:FRAME:VBOX:scrollbar, text and buffer
my $sw = Gtk2::ScrolledWindow->new(undef, undef);
$sw->set_shadow_type ('etched-out');
$sw->set_policy ('automatic', 'automatic');
$sw->set_size_request (300, 500);
$sw->set_border_width(5);
my $text = Gtk2::TextView->new();
$text->set_editable(FALSE);
$text->set_cursor_visible(FALSE); 
$text->set_wrap_mode ('word');
my $buffer = $text->get_buffer();
$buffer->set_text($content);
$sw->add_with_viewport($text);
$vbox->pack_start($sw, FALSE, FALSE, 4);

#HBOX:FRAME:VBOX:COM(userinput)
my $com = Gtk2::VBox->new(FALSE, 5);
my $entryframe = Gtk2::Frame->new("Communicate");
$entryframe->set_border_width(5);
my $entry = Gtk2::Entry->new_with_max_length(30);
$com->pack_start($entry, FALSE, FALSE, 4);
$entryframe->add($com);

#HBOX:FRAME:VBOX:COM(button)
my $button = Gtk2::Button->new("Tell me what to do.");
$button->signal_connect('clicked' => sub{
													my $fortune = `fortune`;
													my $input = $entry->get_text;
													$entry->set_text("");
													if($input =~ /$answer[$position]/i){
														$buffer->set_text($text[$position]);
														$position++;
													}elsif($input =~ /ask fortune/i){
														$buffer->set_text($fortune);
													}else{$buffer->insert_at_cursor("\nSherlock Holmes laughs scornfully.");};
												});
$com->pack_start($button, FALSE, FALSE, 4);
$vbox->pack_end($entryframe, FALSE, FALSE, 4);
$frame->add($vbox);

#HBOX:packVBOX
$hbox->pack_start($frame, TRUE, FALSE, 4);

#the end
$window->add($hbox);
$window->show_all;
Gtk2->main;