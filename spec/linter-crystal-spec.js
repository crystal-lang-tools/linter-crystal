"use babel";

describe('The Crystal provider for AtomLinter', () => {
  const lint = require('../lib/linter-crystal').provideLinter().lint

  beforeEach(() => {
    waitsForPromise(() => {
      return atom.packages.activatePackage("linter-crystal")
    })
  })

  it('does not find any errors in "without_errors.cr"', () => {
    waitsForPromise(() => {
      return atom.workspace.open(__dirname + '/files/without_errors.cr').then(editor => {
        return lint(editor).then(messages => {
          expect(messages.length).toEqual(0)
        })
      })
    })
  })

  it('finds an error in "incorrect_method_type.cr"', () => {
    waitsForPromise(() => {
      return atom.workspace.open(__dirname + '/files/incorrect_method_type.cr').then(editor => {
        return lint(editor).then(messages => {
          expect(messages.length).toEqual(1)
          expect(messages[0].type).toEqual("error")
          expect(messages[0].text).toEqual("no overload matches 'accepts_int' with type String\nOverloads are:\n - accepts_int(int : Int)")
        })
      })
    })
  })

  it('finds an error in "relative_requirement.cr"', () => {
    waitsForPromise(() => {
      return atom.workspace.open(__dirname + '/files/relative_requirement.cr').then(editor => {
        return lint(editor).then(messages => {
          expect(messages.length).toEqual(1)
          expect(messages[0].type).toEqual("error")
          expect(messages[0].text).toEqual("declaring the type of a local variable is not yet supported")
        })
      })
    })
  })

  it('finds an error in "variable_type_already_defined.cr"', () => {
    waitsForPromise(() => {
      return atom.workspace.open(__dirname + '/files/variable_type_already_defined.cr').then(editor => {
        return lint(editor).then(messages => {
          expect(messages.length).toEqual(1)
          expect(messages[0].type).toEqual("error")
          expect(messages[0].text).toEqual("declaring the type of a local variable is not yet supported")
        })
      })
    })
  })
})
