"use babel";

describe('The Crystal provider for AtomLinter', () => {
  const lint = require('../lib/linter-crystal').provideLinter().lint

  beforeEach(() => {
    waitsForPromise(() => {
      return atom.packages.activatePackage("linter-crystal")
    })
  })

  it('finds an error in "incorrect_method_type.cr"', () => {
    waitsForPromise(() => {
      return atom.workspace.open(__dirname + '/files/incorrect_method_type.cr').then(editor => {
        return lint(editor).then(messages => {
          expect(messages.length).toEqual(1)
          //expect(messages[0].file).toEqual(__dirname + '/files/incorrect_method_type.cr')
          expect(messages[0].type).toEqual("error")
          expect(messages[0].text).toEqual("no overload matches 'accepts_int' with types String\nOverloads are:\n - accepts_int(int : Int)")
        })
      })
    })
  })
})
