package;

class Main extends lime.app.Application {
	
	public override function render(context:lime.graphics.RenderContext):Void {		
		switch (context.type) {			
			case OPENGL, OPENGLES, WEBGL:				
				var gl = context.webgl;				
				gl.clearColor (0.75, 1, 0, 1);
				gl.clear (gl.COLOR_BUFFER_BIT);			
			default:			
		}		
	}
	
	
	public function new() {
		
		super ();
		
		// invoking tree-sitter.js and its .wasm
		js.Syntax.code("
		
			const Parser = window.TreeSitter;
			
			Parser.init().then( () => {
				
				
				// loading the javascript grammar
				const jsParser = new Parser;
				Parser.Language.load('lib/tree-sitter-glsl.wasm').then ( (language) => {
					jsParser.setLanguage(language);
					this.treeSitterJS(jsParser);
				});
				
				
				const glslParser = new Parser;
				// loading the glsl grammar
				Parser.Language.load('lib/tree-sitter-glsl.wasm').then ( (language) => {
					glslParser.setLanguage(language);
					this.treeSitterGLSL(glslParser);
				});
				
				
			});
			
		");
		
	}
	
	// callbacks after the language-parsers is ready to use
	
	// ----- testing javascript parsing ---------
	
	public function treeSitterJS(parser:Dynamic) {
		
		// trace("ready", parser);
		
		var sourceCode = 'let x = 1; console.log(x);';
		
		var tree = parser.parse(sourceCode);
		
		//js.Syntax.code("console.log(tree);");
		trace( tree.rootNode.toString() );
		
		var callExpression = tree.rootNode.child(1).firstChild;
		trace(callExpression);

		
		// change something inside source
		var newSourceCode = 'let x = "a"; console.log(x);';

		tree.edit({
		  startIndex: 8,
		  oldEndIndex: 9,
		  newEndIndex: 11,
		  startPosition: {row: 0, column: 8},
		  oldEndPosition: {row: 0, column: 9},
		  newEndPosition: {row: 0, column: 11},
		});

		var newTree = parser.parse(newSourceCode, tree);
		trace( newTree.rootNode.toString() );
	}
	

	// ----- testing glsl parsing ---------
	
	public function treeSitterGLSL(parser:Dynamic) {
		
		// trace("ready", parser);
		
		var sourceCode = 'vec3 xyz;';
		
		var tree = parser.parse(sourceCode);
		
		//js.Syntax.code("console.log(tree);");
		trace( tree.rootNode.toString() );
	
	}
	
	
}