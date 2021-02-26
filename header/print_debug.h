#ifndef PRINT_DEBUG_H
#define PRINT_DEBUG_H

#ifdef DEBUG
  #define _print(...) __print(__VA_ARGS__)
#else
  #define _print(...) 
#endif

class Arg_type {
public:
  enum Type { INT, DOUBLE, CHAR_POINTER, CONST_CHAR_POINTER};
  Type this_type;
  union {
    int int_value;
    double dbl_value;
    char* chp_value;
    const char* cchp_value;

  } u;
 public:

  Arg_type(int value) : this_type(Type::INT) { u.int_value = value; }
  Arg_type(double value) : this_type(Type::DOUBLE) { u.dbl_value = value; }
  Arg_type(const char* value) : this_type(Type::CONST_CHAR_POINTER) { u.cchp_value = value; }
  Arg_type(char* value) : this_type(Type::CHAR_POINTER) { u.chp_value = value; }

  // other types
  void print()
  {
    switch(this_type)
    {
        case Type::INT:
          std::cout << u.int_value << " ";
        break;
        case Type::DOUBLE:
          std::cout << u.dbl_value << " ";
        break;
        case Type::CHAR_POINTER:
          std::cout << u.chp_value << " ";
        break;
        case Type::CONST_CHAR_POINTER:
          std::cout << u.cchp_value << " ";
        break;

    }
  }
};

template< class... Args>
void __print(Args... args)
{
  const std::size_t size = sizeof...(Args);
  Arg_type array[] = {args...};

  for(unsigned int i = 0; i < size; i++)
  {
    array[i].print();
  }
  std::cout << "\n";
}

#endif
