import test;
import example;
import std;

//using namespace test;
//using namespace with_lambdas;

int main()
{
    test::with_lambdas::foo(1);
    test::with_lambdas::bar(1.0);
    test::with_lambdas::bar(2);

    std::clog << "test" << std::endl;
}
