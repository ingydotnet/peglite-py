from package.unittest import *

class TestImport(TestCase):
    def test_import(self):
        import peglite

        self.assertTrue(True, 'peglite module imported cleanly')

if __name__ == '__main__':
    main()
