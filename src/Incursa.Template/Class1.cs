// <copyright file="Class1.cs" company="Incursa">
// CONFIDENTIAL - Copyright (c) Incursa. All rights reserved.
// See NOTICE.md for full restrictions and usage terms.
// </copyright>

namespace Incursa.Template;

public static class Class1
{
    public static string TypeName() => typeof(Class1).FullName ?? nameof(Class1);
}
