// <copyright file="SanityTests.cs" company="Bravellian">
// CONFIDENTIAL - Copyright (c) Bravellian. All rights reserved.
// See NOTICE.md for full restrictions and usage terms.
// </copyright>

namespace Bravellian.Template.Tests;

[TestClass]
public sealed class SanityTests
{
    [TestMethod]
    public void TypeName_ReturnsExpectedValue()
    {
        Assert.AreEqual("Bravellian.Template.Class1", global::Bravellian.Template.Class1.TypeName());
    }
}
