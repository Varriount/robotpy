// SIP support for std::vector
// by Giovanni Bajo <rasky@develer.com>
// Public domain


// ****************************************************
// SIP generic implementation for std::vector<>
// ****************************************************
// ALas, this template-based generic implementation is valid only
// if the element type is a SIP-wrapped type. For basic types (int, double, etc.)
// we are forced to cut & paste to provide a specialization.

template<TYPE>
%MappedType std::vector<TYPE>
{
%TypeHeaderCode
#include <vector>
%End

%ConvertFromTypeCode
   PyObject *l;

   // Create the Python list of the correct length.
   if ((l = PyList_New(sipCpp -> size())) == NULL)
       return NULL;

   // Go through each element in the C++ instance and convert it to a
   // wrapped P2d.
   for (int i = 0; i < (int)sipCpp -> size(); ++i)
   {
       TYPE *cpp = new TYPE(sipCpp -> at(i));
       PyObject *pobj;

       // Get the Python wrapper for the Type instance, creating a new
       // one if necessary, and handle any ownership transfer.
       if ((pobj = sipConvertFromInstance(cpp, sipClass_TYPE, sipTransferObj)) == NULL)
       {
           // There was an error so garbage collect the Python list.
           Py_DECREF(l);
           return NULL;
       }

       // Add the wrapper to the list.
       PyList_SET_ITEM(l, i, pobj);
   }

   // Return the Python list.
   return l;
%End

%ConvertToTypeCode
   // Check if type is compatible
   if (sipIsErr == NULL)
   {
       // Must be any iterable
       PyObject *i = PyObject_GetIter(sipPy);
       bool iterable = (i != NULL);
       Py_XDECREF(i);
       return iterable;
   }

   // Iterate over the object
   PyObject *iterator = PyObject_GetIter(sipPy);
   PyObject *item;

   std::vector<TYPE> *V = new std::vector<TYPE>();

   while ((item = PyIter_Next(iterator)))
   {
       if (!sipCanConvertToInstance(item, sipClass_TYPE, SIP_NOT_NONE))
       {
           PyErr_Format(PyExc_TypeError, "object in iterable cannot be converted to TYPE");
           *sipIsErr = 1;
           break;
       }

       int state;
       TYPE* p = reinterpret_cast<TYPE*>(
            sipConvertToInstance(item, sipClass_TYPE, 0, SIP_NOT_NONE, &state, sipIsErr));

       if (!*sipIsErr)
           V->push_back(*p);

       sipReleaseInstance(p, sipClass_TYPE, state);
       Py_DECREF(item);
   }

   Py_DECREF(iterator);

   if (*sipIsErr)
   {
       delete V;
       return 0;
   }

   *sipCppPtr = V;
   return sipGetState(sipTransferObj);
%End
};

// ****************************************************
// Specialization for std::vector<double>
// ****************************************************

%MappedType std::vector<double>
{
%TypeHeaderCode
#include <vector>
%End

%ConvertFromTypeCode
   PyObject *l;

   // Create the Python list of the correct length.
   if ((l = PyList_New(sipCpp -> size())) == NULL)
       return NULL;

   // Go through each element in the C++ instance and convert it to a
   // wrapped object.
   for (int i = 0; i < (int)sipCpp -> size(); ++i)
   {
       // Add the wrapper to the list.
       PyList_SET_ITEM(l, i, PyFloat_FromDouble(sipCpp -> at(i)));
   }

   // Return the Python list.
   return l;
%End

%ConvertToTypeCode
   // Check if type is compatible
   if (sipIsErr == NULL)
   {
       // Must be any iterable
       PyObject *i = PyObject_GetIter(sipPy);
       bool iterable = (i != NULL);
       Py_XDECREF(i);
       return iterable;
   }

   // Iterate over the object
   PyObject *iterator = PyObject_GetIter(sipPy);
   PyObject *item;

   // Maximum number of elements
   int len = PyObject_Size(sipPy);
   std::vector<double> *V = new std::vector<double>();
   V->reserve(len);

   if (len)
   {
       while ((item = PyIter_Next(iterator)))
       {
           if (!PyNumber_Check(item))
           {
               PyErr_Format(PyExc_TypeError, "object in iterable is not a number");
               *sipIsErr = 1;
               break;
           }

           PyObject *f = PyNumber_Float(item);
           V->push_back(PyFloat_AsDouble(f));

           Py_DECREF(f);
           Py_DECREF(item);
       }

       Py_DECREF(iterator);

       if (*sipIsErr)
       {
           delete V;
           return 0;
       }
   }

   *sipCppPtr = V;
   return sipGetState(sipTransferObj);
%End
};


// ****************************************************
// Specialization for std::vector<int>
// ****************************************************

%MappedType std::vector<int>
{
%TypeHeaderCode
#include <vector>
%End

%ConvertFromTypeCode
   PyObject *l;

   // Create the Python list of the correct length.
   if ((l = PyList_New(sipCpp -> size())) == NULL)
       return NULL;

   // Go through each element in the C++ instance and convert it to a
   // wrapped object.
   for (int i = 0; i < (int)sipCpp -> size(); ++i)
   {
       // Add the wrapper to the list.
       PyList_SET_ITEM(l, i, PyLong_FromLong(sipCpp -> at(i)));
   }

   // Return the Python list.
   return l;
%End

%ConvertToTypeCode
   // Check if type is compatible
   if (sipIsErr == NULL)
   {
       // Must be any iterable
       PyObject *i = PyObject_GetIter(sipPy);
       bool iterable = (i != NULL);
       Py_XDECREF(i);
       return iterable;
   }

   // Iterate over the object
   PyObject *iterator = PyObject_GetIter(sipPy);
   PyObject *item;

   // Maximum number of elements
   int len = PyObject_Size(sipPy);
   std::vector<int> *V = new std::vector<int>();
   V->reserve(len);

   if (len)
   {
       while ((item = PyIter_Next(iterator)))
       {
           if (!PyLong_Check(item))
           {
               PyErr_Format(PyExc_TypeError, "object in iterable cannot be converted to int");
               *sipIsErr = 1;
               break;
           }

           int val = PyLong_AsLong(item);
           V->push_back(val);

           Py_DECREF(item);
       }

       Py_DECREF(iterator);

       if (*sipIsErr)
       {
           delete V;
           return 0;
       }
   }

   *sipCppPtr = V;
   return sipGetState(sipTransferObj);
%End
};
