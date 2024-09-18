with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;

package body Assgn is
   
   package Rand is new Ada.Numerics.Discrete_Random (BINARY_NUMBER);
   use Rand;

   Gen: Generator;

   --initialize first array (My_Array) with random binary values
   procedure Init_Array (Arr: in out BINARY_ARRAY) is
   begin
    Reset(Gen);
    for i in Arr'range loop
      Arr(i) := Random(Gen);
    end loop;
   end Init_Array;

   --reverse the binary array
   procedure Reverse_Bin_Arr(Arr: in out BINARY_ARRAY) is
   begin
    for i in Arr'range loop
      if i < Arr'length - i + 1 then
       swap(Arr(i), Arr(Arr'length - i + 1));
      else
       exit;
      end if;
    end loop;
   end Reverse_Bin_Arr;

   --print Binary array procedure
   procedure Print_Bin_Arr(Arr: in BINARY_ARRAY) is
   begin
    for i in Arr'range loop
      Put(Arr(i));
    end loop;
    New_Line;
   end Print_Bin_Arr;

   --integer to binary conversion
   function Int_To_Bin(Num: in INTEGER) return BINARY_ARRAY is
    Arr: BINARY_ARRAY := (others => BINARY_NUMBER(0));
    Temp: INTEGER := Num;
   begin
    for i in reverse Arr'range loop
      Arr(i) := Temp mod 2;
      Temp := Temp / 2;
    end loop;
    Reverse_Bin_Arr(Arr);
    return Arr;
   end Int_To_Bin;

   --Binary to integer conversion
   function Bin_To_Int(Arr: in BINARY_ARRAY) return INTEGER is
    Result: INTEGER := 0;
    Mult: Integer := 1;
   begin
    for i in reverse Arr'range loop
      Result := Result + Integer(Arr(i)) * Mult;
      Mult := Mult * 2;
    end loop;
    return Result;
   end Bin_To_Int;

   -- "+" overload to add two binary arrays together; returns a binary array
   function "+" (Left, Right: in BINARY_ARRAY) return BINARY_ARRAY is
    Result: BINARY_ARRAY;
    Carry: Integer := 0;
   begin
    for i in reverse Left'range loop
      if Carry = 0 then
       if Left(i) = 1 and Right(i) = 1 then
         Result(i) := BINARY_NUMBER(0);
         Carry := 1;
       elsif Left(i) = 0 and Right(i) = 0 then
         Result(i) := BINARY_NUMBER(0);
       else
         Result(i) := BINARY_NUMBER(1);
       end if;
      elsif Carry = 1 then
       if Left(i) = 1 and Right(i) = 1 then
         Result(i) := BINARY_NUMBER(1);
       elsif Left(i) = 0 and Right(i) = 0 then
         Result(i) := BINARY_NUMBER(1);
         Carry := 0;
       else
         Result(i) := BINARY_NUMBER(0);
       end if;
      end if;
    end loop;
    return Result;
   end "+";

   -- "+" overload to add an integer to a binary array; returns a binary array
   function "+" (Left : in INTEGER; Right : in BINARY_ARRAY) return BINARY_ARRAY is
   begin
    return Int_To_Bin(Left) + Right;
   end "+";

   function "-" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
    Ones_Complement: BINARY_ARRAY := Right;
   begin
    -- Find the ones complement of Right
    for i in Ones_Complement'range loop
      if Ones_Complement(i) = 0 then
         Ones_Complement(i) := 1;
      else
         Ones_Complement(i) := 0;
      end if;
    end loop;

    -- Add ones complement of Right to Left
    return Left + Ones_Complement + Int_To_Bin(1);
   end "-";

   -- "-" overload to subtract an integer from a binary array; returns a binary array
   function "-" (Left : in Integer; Right : in BINARY_ARRAY) return BINARY_ARRAY is
   begin
    return Int_To_Bin(Left) - Right;
   end "-";

end Assgn;
