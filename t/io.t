use strict;
use warnings;
use Compiler::Lexer;
use Compiler::Parser;
use Compiler::Parser::AST::Renderer;
use Compiler::CodeGenerator::LLVM;

my $code = do { local $/; <DATA> };
my $tokens = Compiler::Lexer->new('')->tokenize($code);
my $ast = Compiler::Parser->new->parse($tokens);
Compiler::Parser::AST::Renderer->new()->render($ast);

my $llvm_ir = Compiler::CodeGenerator::LLVM->new->generate($ast);

open my $fh, '>', 'io.ll';
print $fh $llvm_ir;
close $fh;

warn "generated";

Compiler::CodeGenerator::LLVM->new->debug_run($ast);

__DATA__

sub f {
    $_[0] = 2;
    return 1;
}

my $a = 1;
say $a;
f($a);
say $a;

my $fh;
open $fh, ">", "hoge.pl";
print $fh "hello world";
close $fh;
