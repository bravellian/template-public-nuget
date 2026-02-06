// <copyright file="SanityTests.cs" company="Incursa">
// CONFIDENTIAL - Copyright (c) Incursa. All rights reserved.
// See NOTICE.md for full restrictions and usage terms.
// </copyright>

namespace Incursa.Template.Tests;

[TestClass]
public sealed class SanityTests
{
    [TestMethod]
    public void TypeName_ReturnsExpectedValue()
    {
        Assert.AreEqual("Incursa.Template.Class1", global::Incursa.Template.Class1.TypeName());
    }
}
