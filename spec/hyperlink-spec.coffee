path = require 'path'

describe 'Hyperlink grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-hyperlink')

    runs ->
      grammar = atom.grammars.grammarForScopeName('text.hyperlink')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'text.hyperlink'

  it 'parses http: and https: links', ->
    plainGrammar = atom.grammars.selectGrammar()

    {tokens} = plainGrammar.tokenizeLine 'http://github.com'
    expect(tokens[0]).toEqual value: 'http://github.com', scopes: ['text.plain.null-grammar', 'markup.underline.link.http.hyperlink']

    {tokens} = plainGrammar.tokenizeLine 'https://github.com'
    expect(tokens[0]).toEqual value: 'https://github.com', scopes: ['text.plain.null-grammar', 'markup.underline.link.https.hyperlink']

    {tokens} = plainGrammar.tokenizeLine 'http://twitter.com/#!/AtomEditor'
    expect(tokens[0]).toEqual value: 'http://twitter.com/#!/AtomEditor', scopes: ['text.plain.null-grammar', 'markup.underline.link.http.hyperlink']

    {tokens} = plainGrammar.tokenizeLine 'https://github.com/atom/brightray_example'
    expect(tokens[0]).toEqual value: 'https://github.com/atom/brightray_example', scopes: ['text.plain.null-grammar', 'markup.underline.link.https.hyperlink']

  it 'parses http: and https: links that contains unicode characters', ->
    plainGrammar = atom.grammars.selectGrammar()

    {tokens} = plainGrammar.tokenizeLine 'https://sv.wikipedia.org/wiki/Mañana'
    expect(tokens[0]).toEqual value: 'https://sv.wikipedia.org/wiki/Mañana', scopes: ['text.plain.null-grammar', 'markup.underline.link.https.hyperlink']

  it 'does not parse links in a regex string', ->
    testGrammar = atom.grammars.loadGrammarSync(path.join(__dirname, 'fixtures', 'test-grammar.cson'))

    {tokens} = testGrammar.tokenizeLine 'regexp:http://github.com'
    expect(tokens[1]).toEqual value: 'http://github.com', scopes: ['source.test', 'string.regexp.test']

  describe 'parsing cfml strings', ->

    it 'does not include anything between (and including) pound signs', ->
      plainGrammar = atom.grammars.selectGrammar()
      {tokens} = plainGrammar.tokenizeLine 'http://github.com/#username#'
      expect(tokens[0]).toEqual value: 'http://github.com/', scopes: ['text.plain.null-grammar', 'markup.underline.link.http.hyperlink']

    it 'still includes single pound signs', ->
      plainGrammar = atom.grammars.selectGrammar()
      {tokens} = plainGrammar.tokenizeLine 'http://github.com/atom/#start-of-content'
      expect(tokens[0]).toEqual value: 'http://github.com/atom/#start-of-content', scopes: ['text.plain.null-grammar', 'markup.underline.link.http.hyperlink']
