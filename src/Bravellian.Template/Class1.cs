// <copyright file="Class1.cs" company="Bravellian">
// CONFIDENTIAL - Copyright (c) Bravellian. All rights reserved.
// See NOTICE.md for full restrictions and usage terms.
// </copyright>

namespace Bravellian.Template;

public static class Class1
{
    public static string TypeName() => typeof(Class1).FullName ?? nameof(Class1);
}
