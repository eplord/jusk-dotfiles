#!/usr/bin/env perl
use strict;
use warnings;


use Archive::Tar;
use File::Temp ();
use IPC::System::Simple qw(capture);
use LWP::Simple;


print "Setting up...\n";

# GitHub repository to clone
my $author =     $ENV{'DOTFILES_AUTHOR'}     // 'andrejusk';
my $repository = $ENV{'DOTFILES_REPOSITORY'} // 'dotfiles';
my $branch =     $ENV{'DOTFILES_BRANCH'}     // 'master';
print "Using repository $author/$repository at $branch\n";

# Installer filename
my $installer = $ENV{'DOTFILES_INSTALLER'} // 'install.sh';
print "Using installer $installer\n";

# Download repo
my $repository_url = "https://github.com/$author/$repository/archive/$branch.tar.gz";
my $temp_handle = File::Temp->new();
my $repository_temp = $temp_handle->filename;
print "Downloading $repository_url to $repository_temp\n";
getstore($repository_url, $repository_temp);

# Extract repo
my $temp_dir = File::Temp->newdir();
my $tar = Archive::Tar->new;
print "Extracting $repository_temp to $temp_dir\n";
$tar->read($repository_temp);
$tar->setcwd($temp_dir);
$tar->extract();

# Install repo
my $installer_path = "$temp_dir/$repository-$branch/$installer";
print 'Running installer <' . $installer_path . ">\n";
my $output = capture([0,1,2], $^X, $installer_path);
print $output;
