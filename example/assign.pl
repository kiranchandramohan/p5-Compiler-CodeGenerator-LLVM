use strict;
use warnings;
use Compiler::Lexer;
use Compiler::Parser;
use Compiler::Parser::AST::Renderer;
use Compiler::CodeGenerator::LLVM;

my $code = do { local $/; <DATA> };
my $tokens = Compiler::Lexer->new('')->tokenize($code);
my $parser = Compiler::Parser->new();
my $ast = $parser->parse($tokens);
Compiler::Parser::AST::Renderer->new->render($ast);
my $generator = Compiler::CodeGenerator::LLVM->new();
my $llvm_ir = $generator->generate($ast);
open my $fh, '>', 'assign.ll';
print $fh $llvm_ir;
close $fh;

$generator = Compiler::CodeGenerator::LLVM->new();
$generator->debug_run($ast);

__DATA__
my $a = 10;

$a += 2;
say $a;
$a -= 2;
say $a;
$a *= 2;
say $a;
$a /= 2;
say $a;
